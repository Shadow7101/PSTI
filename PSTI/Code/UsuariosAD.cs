using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.DirectoryServices;
using System.DirectoryServices.AccountManagement;
using System.Security.Principal;
using System.Threading;

namespace PSTI.Code
{
    //http://theclub.com.br/Restrito/Revistas/201802/LING1802.ASPX


    public static class UsuariosAD
    {
        public static Model.Usuario GetUsuario()
        {
            var identity = WindowsIdentity.GetCurrent();
            var principal = (GenericPrincipal)Thread.CurrentPrincipal;
            var Groups = Grupos(identity);

            string login = identity.Name;
            string dominio = TrataNomeDominio(ref login);

            DirectoryEntry entry = new DirectoryEntry("LDAP://" + dominio);
            PrincipalContext principalContext = new PrincipalContext(ContextType.Domain);
            DirectorySearcher directorySearcher = new DirectorySearcher(principalContext.ConnectedServer);

            directorySearcher.Filter = "(sAMAccountName=" + login + ")"; //usuário
            directorySearcher.PropertiesToLoad.Add("mail");  // e-mail addressead
            directorySearcher.PropertiesToLoad.Add("extensionAttribute1");  // matricula
            directorySearcher.PropertiesToLoad.Add("extensionAttribute2");  // cpf
            directorySearcher.PropertiesToLoad.Add("displayname");  // nome de exibição
            directorySearcher.PropertiesToLoad.Add("givenname");  // primeiro nome
            directorySearcher.PropertiesToLoad.Add("sn");  // segundo nome
            directorySearcher.PropertiesToLoad.Add("title");  // cargo
            directorySearcher.PropertiesToLoad.Add("telephonenumber");  // telefone
            directorySearcher.PropertiesToLoad.Add("department");  // departamento
            directorySearcher.PropertiesToLoad.Add("company");  // Empresa
            directorySearcher.PropertiesToLoad.Add("physicaldeliveryofficename");  // Local de trabalho
            //directorySearcher.PropertiesToLoad.Add("thumbnailphoto");  // foto

            SearchResult searchResult = directorySearcher.FindOne();

            string Nome = (searchResult.Properties["displayname"].Count > 0) ? searchResult.Properties["displayname"][0].ToString() : null;
            string PrimeiroNome = (searchResult.Properties["givenname"].Count > 0) ? searchResult.Properties["givenname"][0].ToString() : null;
            string Sobrenome = (searchResult.Properties["sn"].Count > 0) ? searchResult.Properties["sn"][0].ToString() : null;
            string Email = (searchResult.Properties["mail"].Count > 0) ? searchResult.Properties["mail"][0].ToString() : null;
            string Matricula = (searchResult.Properties["extensionAttribute2"].Count > 0) ? searchResult.Properties["extensionAttribute2"][0].ToString() : null;
            string CPF = (searchResult.Properties["extensionAttribute1"].Count > 0) ? searchResult.Properties["extensionAttribute1"][0].ToString() : null;
            string Cargo = (searchResult.Properties["title"].Count > 0) ? searchResult.Properties["title"][0].ToString() : null;
            string Telefone = (searchResult.Properties["telephonenumber"].Count > 0) ? searchResult.Properties["telephonenumber"][0].ToString() : null;
            string Departamento = (searchResult.Properties["department"].Count > 0) ? searchResult.Properties["department"][0].ToString() : null;
            string Empresa = (searchResult.Properties["company"].Count > 0) ? searchResult.Properties["company"][0].ToString() : null;
            string Escritorio = (searchResult.Properties["physicaldeliveryofficename"].Count > 0) ? searchResult.Properties["physicaldeliveryofficename"][0].ToString() : null;
            
            return new Model.Usuario(identity.Name, Nome, PrimeiroNome, Sobrenome, Email, Matricula, CPF, Cargo, Telefone, Departamento, Empresa, Escritorio, Groups);
        }
        private static string[] Grupos(WindowsIdentity identity)
        {
            var groups = new List<string>();
            foreach (var groupId in identity.Groups)
            {
                var group = groupId.Translate(typeof(NTAccount));
                groups.Add(group.Value);
            }
            return groups.ToArray();
        }

        private static string TrataNomeDominio(ref string usuario)
        {
            string dominio = null;

            if (usuario.Contains("\\"))
            {
                dominio = usuario.Split('\\')[0];
                usuario = usuario.Split('\\')[1];
            }
            else
            {
                dominio = "seesp";
            }

            return dominio;
        }
    }
}
