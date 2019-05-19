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

        // GET api/films/list?page=1&size=5
        [HttpGet]
        public List<Film> List(int? page = null, int? size = null)
        {
            return _filmRepository.FilmList(pageNumber: page, pageSize: size);
        }

        // GET api/films/list/5
        [HttpGet]
        public Film List(int id)
        {
            return _filmRepository.FilmItem(filmId: id);
        }

        // POST api/films/add
        [HttpPost]
        public Film Add([FromBody]Film film)
        {
            var i = _filmRepository.FilmSave(film);
            film.FilmId = i;

            return film;
        }

        // PUT api/films/edit
        [HttpPut]
        public Film Edit([FromBody]Film film)
        {
            _filmRepository.FilmSave(film);

            return film;
        }

        // DELETE api/films/delete/5
        [HttpDelete]
        public void Delete(int id)
        {
            _filmRepository.FilmDelete(id);
        }

        // GET api/films/count
        [HttpGet]
        public int Count()
        {
            return _filmRepository.FilmCount();
        }

        // GET api/films/countries
        [HttpGet]
        public List<Country> Countries()
        {
            return _filmRepository.CountryList();
        }

        // GET api/films/directors
        [HttpGet]
        public List<Director> Directors()
        {
            return _filmRepository.DirectorList();
        }

        // GET api/films/actors
        [HttpGet]
        public List<Actor> Actors()
        {
            return _filmRepository.ActorList();
        }

        // GET api/films/ganres
        [HttpGet]
        public List<Ganre> Ganres()
        {
            return _filmRepository.GanreList();
        }
    }
}
