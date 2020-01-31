using System;

namespace PSTI.Library.Domain
{
    public class Processo
    {
        public int Id { get; set; }
        public string Nome { get; set; }
        public string Descricao { get; set; }
        public bool Ativo { get; set; }
        public DateTime Data { get; set; }
        public string Regulamento { get;  set; }
        public DateTime DataInicio { get;  set; }
        public DateTime DataTermino { get;  set; }
        public bool BloquearEstacao { get; set; }
        public string Perfil { get; set; }
    }
}
