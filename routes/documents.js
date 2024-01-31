const express = require('express');
const bcrypt = require('bcrypt');
const router = express.Router();

const options = require('../configuration/options');
const { executeQuery } = require('../configuration/database');

router.get('/:id', async function(req, res, next) {
    try {
        if(!req.session.loggedIn)
            return res.status(401).json({ message: 'Not logged in' });

        const id = req.params.id;
        if(!id)
            return res.status(401).json({ message: 'ID not provided.' });

        // check privileges
        const priv_sql = 'SELECT READ_PRIVILEEG FROM dokument_privileegid WHERE kasutaja_id=?';
        const priv_result = await executeQuery(priv_sql, [req.session.user.userId]);
        if(!priv_result || priv_result.length === 0 || priv_result[0].READ_PRIVILEEG === 0)
            return res.status(401).json({ message: 'Not authorized.' });

        // get the document
        const sql = 'SELECT * FROM dokument WHERE id=?';
        const result = await executeQuery(sql, [id]);

        if(!result || result.length === 0)
            return res.status(401).json({ message: 'Document not found.' });

        return res.status(202).json({ message: 'Success.', data: result[0] });
    } catch(error) {
        console.error(error);

       if(options.diagnostic)
           return res.status(500).json({ error: error.message });
       else {
           return res.status(500).json({ error: 'Server error.' });
       }
    }
});

router.put('/:id/privileges', async function(req, res, next) {
    try {
        if(!req.session.loggedIn)
            return res.status(401).json({ message: 'Not logged in' });

        const id = req.params.id;
        if(!id)
            return res.status(401).json({ message: 'ID not provided.' });

        const email = req.body.email;
        if(!email || email.length <= 0 || !/^[a-zA-Z0-9._%+-]+@voco\.ee$/.test(email))
            return res.status(401).json({ message: 'Email address not provided or invalid' });

        const privileges = req.body.privileges;
        if(!privileges || privileges.length <= 0)
            return res.status(401).json({ message: 'Privileges not provided or invalid' });

        // check if is owner of the document
        const priv_sql = 'SELECT omanik_id FROM dokument WHERE ID=?';
        const priv_result = await executeQuery(priv_sql, [id]);
        if(!priv_result || priv_result.length === 0 || priv_result[0].omanik_id !== req.session.user.userId)
            return res.status(401).json({ message: 'Not authorized.' });

        const get_user_sql = 'SELECT ID FROM kasutaja WHERE email=?';
        const get_user_result = await executeQuery(get_user_sql, [email]);

        if(!get_user_result || get_user_result.length === 0)
            return res.status(401).json({ message: 'User not found to update.' });

        const duplicate_entry = 'SELECT * FROM dokument_privileegid WHERE DOKUMENT_ID=? AND KASUTAJA_ID=?';
        const duplicate_entry_result = await executeQuery(duplicate_entry, [id, get_user_result[0].ID])

        let final;
        if(!duplicate_entry_result) {
            const insert_query = 'INSERT INTO dokument_privileegid (DOKUMENT_ID, KASUTAJA_ID, READ_PRIVILEEG, WRITE_PRIVILEEG, DELETE_PRIVILEEG) VALUES (?, ?, ?, ?, ?)';
            final = await executeQuery(insert_query, [id, get_user_result[0].ID, privileges.READ_PRIVILEEG, privileges.WRITE_PRIVILEEG, privileges.DELETE_PRIVILEEG]);
        } else {
            const update_query = 'UPDATE dokument_privileegid SET READ_PRIVILEEG=?, WRITE_PRIVILEEG=?, DELETE_PRIVILEEG=? WHERE DOKUMENT_ID=? AND KASUTAJA_ID=?';
            final = await executeQuery(update_query, [privileges.READ_PRIVILEEG, privileges.WRITE_PRIVILEEG, privileges.DELETE_PRIVILEEG, id, get_user_result[0].ID])
        }

        if(final.changedRows === 0)
            return res.status(401).json({ message: 'Failed to update. Data identical to server or server issue.' });

        return res.status(202).json({ message: 'Success.' });
    } catch(error) {
        console.error(error);

       if(options.diagnostic)
           return res.status(500).json({ error: error.message });
       else {
           return res.status(500).json({ error: 'Server error.' });
       }
    }
});

router.delete('/', async function(req, res) {
   try {
       if(!req.session.loggedIn)
           return res.status(401).json({ message: 'Not logged in.' });



        return res.status(200).json({ message: 'Deleted document.' });
   } catch(error) {
       console.error(error);

       if(options.diagnostic)
           return res.status(500).json({ error: error.message });
       else {
           return res.status(500).json({ error: 'Server error.' });
       }
   }
});

module.exports = router;