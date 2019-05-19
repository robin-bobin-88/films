namespace Films.Models
{
    public class Ganre
    {
        public int GanreId { get; set; }
        public string GanreName { get; set; }
        public string Type { get; set; }        

        public Ganre()
        {
            Type = "danger";
        }
    }
}