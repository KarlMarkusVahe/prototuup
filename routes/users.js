const express = require('express');
const bcrypt = require('bcrypt');
const router = express.Router();

const options = require('../configuration/options');
const { executeQuery } = require('../configuration/database');

router.post('/', async function(req, res, next) {
    try {
        if(req.session.loggedIn)
            return res.status(401).json({ message: 'Already logged in.' });

        const { email, password } = req.body;

        if(!email || !password || email.length <= 0 || password.length <= 0)
            return res.status(401).json({ message: 'Email or password empty.' });

        if(!/^[a-zA-Z0-9._%+-]+@voco\.ee$/.test(email))
            return res.status(401).json({ message: 'Invalid email format.' });

        const sql = 'SELECT ID, EMAIL, PAROOL, OPETAJA, administraator FROM kasutaja WHERE EMAIL=?';
        const result = await executeQuery(sql, [ email ]);

        if(!result || result.length === 0)
            return res.status(401).json( { message: 'User not found.' });

        if(result.length > 1)
            throw new Error('Multiple accounts found for user ' + email);

        const user = result[0];

        const valid = await bcrypt.compare(password, user.PAROOL);
        if(!valid)
            return res.status(401).json({ message: 'Invalid password.' });

        // session stuff
        req.session.user = {
          userId: user.ID,
          email: user.EMAIL,
          powerLevel: user.administraator ? 2 : (user.OPETAJA ? 1 : 0),
        };
        req.session.loggedIn = true;

        if(options.diagnostic) {
            console.log(`[${req.session.user.userId}] authorized with power level ${req.session.user.powerLevel}.`);
        }

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
        req.session.destroy();

        return res.status(200).json({ message: 'Logged out.' });
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
