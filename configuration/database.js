const mysql2 = require('mysql2/promise');
const options = require('./options');

const config = {
    host: 'localhost',
    user: 'root',
    password: 'qwerty',
    database: 'main',
    connectionLimit: 10
}

const pool = mysql2.createPool(config);
let connection;

const executeQuery = async (sql, values) => {
  try {
      if(!connection)
          connection = await pool.getConnection();

      if(options.diagnostic)
        console.warn(`Executing ${sql}, `, values);

      const [rows, fields] = await connection.execute(sql, values);
      return rows;
  } catch (e) {
    console.error(e.message);
  }
};

module.exports = {
    config,
    executeQuery
}