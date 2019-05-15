using System.Collections.Generic;
using System.Linq;

namespace Films.Models
{
    public class Film
    {
        public int FilmId { get; set; }
        public string FilmName { get; set; }
        public int Year { get; set; }
        public string Notice { get; set; }
        public string CountryId { get; set; }
        public string DirectorId { get; set; }

        public Country Country { get; set; }
        public Director Director { get; set; }

        public List<Actor> ActorList { get; set; }
        public List<Ganre> GanreList { get; set; }

        public string Actors => string.Join(", ", ActorList.Select(x => x.ActorName));
        public string Ganres => string.Join(", ", GanreList.Select(x => x.GanreName));

        public Film()
        {
            ActorList = new List<Actor>();
            GanreList = new List<Ganre>();
        }
    }
}