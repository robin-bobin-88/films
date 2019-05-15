using System.Collections.Generic;

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
    }
}