using Dapper;
using Films.Infrastructure.Abstract;
using Films.Models;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.Script.Serialization;

namespace Films.Infrastructure.Concrete
{
    public class FilmRepository : IFilmRepository
    {
        private readonly string _connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
        
        /// <summary>
        /// Список фильмов
        /// </summary>
        public List<Film> FilmList(int? filmId = null, int? pageNumber = null, int? pageSize = null)
        {
            var sql = @"
DECLARE	@return_value NVarChar(MAX)
EXEC	@return_value = [dbo].[FilmList] @filmId, @pageNumber, @pageSize
SELECT	@return_value as 'res'
";
            string res = string.Empty;
            using (IDbConnection db = new SqlConnection(_connectionString))
            {
                res = db.QueryFirst<string>(sql, new
                {
                    filmId,
                    pageNumber,
                    pageSize
                });
            }

            var serializer = new JavaScriptSerializer();
            var list = res != null
                ? serializer.Deserialize<List<Film>>(res)
                : new List<Film>();

            return list;
        }

        /// <summary>
        /// Фильм
        /// </summary>
        public Film FilmItem(int filmId)
        {
            var list = FilmList(filmId);

            if (list.Any())
                return list.FirstOrDefault();
            
            return null;
        }

        /// <summary>
        /// Добавление/Редактирование фильма
        /// </summary>
        public int FilmSave(Film film)
        {
            if (film == null)
                return 0;

            var serializer = new JavaScriptSerializer();
            var filmJson = serializer.Serialize(film);

            var sql = @"
DECLARE	@return_value BIGINT
EXEC	@return_value = [dbo].[FilmSave] @filmJson
SELECT @return_value as 'Return Value'
";
            int res = 0;
            using (IDbConnection db = new SqlConnection(_connectionString))
            {
                res = db.QueryFirst<int>(sql, new { filmJson });
            }

            return res;
        }

        /// <summary>
        /// Удаление фильма
        /// </summary>
        public void FilmDelete(int filmId)
        {
            var sql = @"dbo.FilmDelete";
            
            using (IDbConnection db = new SqlConnection(_connectionString))
            {
                var res = db.Execute(sql, new { filmId }, commandType: CommandType.StoredProcedure);
            }
        }

        /// <summary>
        /// Количество фильмов
        /// </summary>
        public int FilmCount()
        {
            var sql = @"
SELECT COUNT(FilmId) FROM [dbo].[Film]";

            int res = 0;
            using (IDbConnection db = new SqlConnection(_connectionString))
            {
                res = db.QueryFirst<int>(sql);
            }

            return res;
        }
    }
}