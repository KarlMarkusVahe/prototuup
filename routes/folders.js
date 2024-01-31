const express = require('express');
const bcrypt = require('bcrypt');
const router = express.Router();

const options = require('../configuration/options');
const {executeQuery} = require('../configuration/database');

router.get('/', async function (req, res, next) {
    try {
        if (!req.session.loggedIn)
            return res.status(401).json({message: 'Not logged in'});

        const folder_sql = 'WITH FolderResults AS (SELECT f.ID, f._ID, f.PEALKIRI AS FOLDER_PEALKIRI, f.KATEGOORIA FROM folder f WHERE f.omanik_id = ? UNION ALL SELECT f.ID, f._ID, f.PEALKIRI AS FOLDER_PEALKIRI, f.KATEGOORIA FROM folder f JOIN folder_privileegid fp ON f.ID = fp.folder_id WHERE fp.KASUTAJA_ID = ? AND fp.READ_PRIVILEEG = true) SELECT ID, _ID, FOLDER_PEALKIRI AS PEALKIRI, KATEGOORIA FROM FolderResults';
        const folderResults = await executeQuery(folder_sql, [req.session.user.userId, req.session.user.userId]);

        const document_sql = 'WITH DocumentResults AS ( SELECT d.ID AS DocumentID, d.PEALKIRI AS DOKUMENT_PEALKIRI, d.DOKUMENT_TYYP, d.FOLDER_ID AS DocumentFolderID FROM dokument d WHERE d.omanik_id = ? UNION ALL SELECT d.ID AS DocumentID, d.PEALKIRI AS DOKUMENT_PEALKIRI, d.DOKUMENT_TYYP, d.FOLDER_ID AS DocumentFolderID FROM dokument d JOIN dokument_privileegid dp ON d.ID = dp.dokument_id WHERE dp.KASUTAJA_ID = ? AND dp.READ_PRIVILEEG = true ) SELECT DISTINCT DocumentID, DOKUMENT_PEALKIRI, DOKUMENT_TYYP, DocumentFolderID FROM DocumentResults';
        const documentResults = await executeQuery(document_sql, [req.session.user.userId, req.session.user.userId]);

        const combinedData = [];

        function findFolderById(folderArray, folderId) {
            for (const folder of folderArray) {
                if (folder.ID === folderId) {
                    return folder;
                }

                const subFolder = findFolderById(folder.folders, folderId);
                if (subFolder) {
                    return subFolder;
                }
            }

            return null;
        }

        folderResults.forEach(folder => {
            folder.documents = [];
            folder.folders = [];
            if (!folder._ID) {
                combinedData.push(folder);
            }
        });

        folderResults.forEach(subFolder => {
            const parentFolderId = subFolder._ID;
            const parentFolder = combinedData.find(folder => folder.ID === parentFolderId);
            if (parentFolder) {
                parentFolder.folders.push(subFolder);
            }
        });

        documentResults.forEach(document => {
            const parentFolderId = document.DocumentFolderID;
            const parentFolder = findFolderById(combinedData, parentFolderId);
            if (parentFolder) {
                parentFolder.documents.push(document);
            }
        });

        return res.status(202).json({message: 'Success.', data: combinedData});
    } catch (error) {
        console.error(error);

        if (options.diagnostic)
            return res.status(500).json({error: error.message});
        else {
            return res.status(500).json({error: 'Server error.'});
        }
    }
});

router.get('/:id', async function (req, res) {
    try {
        if (!req.session.loggedIn)
            return res.status(401).json({message: 'Not logged in'});

        const folder_id = req.params.id;
        if(!folder_id)
            return res.status(401).json({message: 'Invalid request'});

        // Get the main folder
        const p_sql = 'SELECT DISTINCT f.ID, f._ID, f.PEALKIRI, f.KATEGOORIA FROM folder f LEFT JOIN folder_privileegid fp ON f.ID = fp.folder_id WHERE (f.ID = ? OR f._ID = ?) AND ( f.omanik_id = ? OR (fp.folder_id=? AND fp.KASUTAJA_ID = ? AND fp.READ_PRIVILEEG = true))';
        const p_sql_doc = 'SELECT DISTINCT d.ID AS DocumentID, d.PEALKIRI AS DOKUMENT_PEALKIRI, d.DOKUMENT_TYYP, d.FOLDER_ID AS DocumentFolderID FROM dokument d WHERE (d.omanik_id = ? AND d.FOLDER_ID = ?) OR (d.FOLDER_ID = ? AND EXISTS ( SELECT 1 FROM dokument_privileegid dp WHERE dp.KASUTAJA_ID = ? AND dp.READ_PRIVILEEG = true AND dp.dokument_id = d.ID))';
        // send requests
        const p_sql_data = await executeQuery(p_sql, [folder_id, folder_id, req.session.user.userId, folder_id, req.session.user.userId]);
        const p_sql_doc_data = await executeQuery(p_sql_doc, [req.session.user.userId, folder_id, req.session.user.userId, folder_id]);

        if(!p_sql_data || p_sql_data.length === 0)
            return res.status(401).json({ message: 'Folder does not exist.' });

         function findFolderById(folderArray, folderId) {
            for (const folder of folderArray) {
                if (folder.ID === folderId) {
                    return folder;
                }

                const subFolder = findFolderById(folder.folders, folderId);
                if (subFolder) {
                    return subFolder;
                }
            }

            return null;
        }

        // turn to data
        const combinedData = [];

        p_sql_data.forEach(folder => {
            folder.documents = [];
            folder.folders = [];
            if (!folder._ID || !p_sql_data.find((folderr) => folderr.ID === folder._ID)) {
                combinedData.push(folder);
            }
        });

        p_sql_data.forEach(subFolder => {
            const parentFolderId = subFolder._ID;
            const parentFolder = combinedData.find(folder => folder.ID === parentFolderId);
            if (parentFolder) {
                parentFolder.folders.push(subFolder);
            }
        });

        p_sql_doc_data.forEach(document => {
            const parentFolderId = document.DocumentFolderID;
            const parentFolder = findFolderById(combinedData, parentFolderId);
            if (parentFolder) {
                parentFolder.documents.push(document);
            }
        });

        return res.status(202).json({message: 'Success.', data: combinedData});
    } catch (error) {
        console.error(error);

        if (options.diagnostic)
            return res.status(500).json({error: error.message});
        else {
            return res.status(500).json({error: 'Server error.'});
        }
    }
});

router.delete('/:id', async function (req, res) {
    try {
        if (!req.session.loggedIn)
            return res.status(401).json({message: 'Not logged in.'});



        return res.status(200).json({message: 'Deleted folder.'});
    } catch (error) {
        console.error(error);

        if (options.diagnostic)
            return res.status(500).json({error: error.message});
        else {
            return res.status(500).json({error: 'Server error.'});
        }
    }
});

module.exports = router;