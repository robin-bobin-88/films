using Films.Models;
using System.Collections.Generic;

namespace Films.Infrastructure.Abstract
{
    public interface IFilmRepository
    {
        List<Film> FilmList(int? filmId = null);
        Film FilmItem(int filmId);
        int FilmSave(Film film);
        void FilmDelete(int filmId);
    }
}
