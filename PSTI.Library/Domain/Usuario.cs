using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSTI.Library.Domain
{
    public class Usuario
    {
        public Usuario(string domainName, string nome, string primeiroNome, string sobrenome,
            string email, string matricula, string cpf, string cargo, string telefone,
            string departamento, string empresa, string escritorio, string[] groups)
        {
            this.NomeDeDominio = domainName;
            this.Nome = nome;
            this.PrimeiroNome = primeiroNome;
            this.Sobrenome = sobrenome;
            this.Email = email;
            this.Matricula = matricula;
            this.CPF = cpf;
            this.Cargo = cargo;
            this.Telefone = telefone;
            this.Departamento = departamento;
            this.Empresa = empresa;
            this.Escritorio = escritorio;
            this.Groups = groups;
        }

        public override string ToString()
        {
            return this.NomeDeDominio;
        }
        public string NomeDeDominio { get; }
        public string Nome { get; }
        public string PrimeiroNome { get; }
        public string Sobrenome { get; }
        public string Email { get; }
        public string Matricula { get; }
        public string CPF { get; }
        public string Cargo { get; }
        public string Telefone { get; }
        public string Departamento { get; }
        public string Empresa { get; }
        public string Escritorio { get; }
        public string[] Groups { get; }
    }
}
