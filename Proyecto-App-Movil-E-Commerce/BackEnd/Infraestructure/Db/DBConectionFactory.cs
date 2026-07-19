using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Text;

namespace Infraestructure.Db
{
    public class DBConectionFactory
    {
        private readonly string _connectionString;

        public DBConectionFactory(string connectionString)
        {
            _connectionString = connectionString;
        }

        public SqlConnection CreateConetion()
        {
            return new SqlConnection(_connectionString);
        }
    }
}
