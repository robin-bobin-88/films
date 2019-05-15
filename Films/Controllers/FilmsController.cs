using Films.Infrastructure.Abstract;
using Films.Models;
using System.Collections.Generic;
using System.Web.Http;

namespace Films.Controllers
{
    public class FilmsController : ApiController
    {
        private readonly IFilmRepository _filmRepository;

        public FilmsController(IFilmRepository filmRepository)
        {
            _filmRepository = filmRepository;
        }

        // GET api/values
        [HttpGet]
        public List<Film> Get()
        {
            var list = _filmRepository.FilmList();

            return list;
        }

        // GET api/values/5
        [HttpGet]
        public Film Get(int id)
        {
            var film = _filmRepository.FilmItem(id);

            return film;
        }

        // POST api/values
        [HttpPost]
        public Film Post([FromBody]Film film)
        {
            var i = _filmRepository.FilmSave(film);
            film.FilmId = i;

            return film;
        }

        // PUT api/values/id
        [HttpPut]
        public Film Put(int id, [FromBody]Film film)
        {
            _filmRepository.FilmSave(film);

            return film;
        }

        // DELETE api/values/5
        [HttpDelete]
        public void Delete(int id)
        {
            _filmRepository.FilmDelete(id);
        }
    }
}
