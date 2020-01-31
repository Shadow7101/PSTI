using PSTI.Library.Domain;
using System;
using System.Threading.Tasks;

namespace PSTI.Library.Application
{
    public class Dados : IDisposable
    {
        public string ConnectionString { get; set; }

        public Dados()
        {
            var c = new Criptografia();
            //string teste =c.Criptografa("Server=(local);Database=AceiteEletronico;User Id=sa;Password=P@ssw0rd;");
            string conexaoCriptografada = System.Configuration.ConfigurationManager.AppSettings["PSTI-CON"];
            this.ConnectionString = c.Decriptografa(conexaoCriptografada);
        }

        public async Task<Processo> Processo(int Modulo, int Id = 0)
        {

            Processo processo = null;
            using (var connection = new System.Data.SqlClient.SqlConnection(this.ConnectionString))
            {
                using (var command = connection.CreateCommand())
                {
                    command.CommandType = System.Data.CommandType.StoredProcedure;
                    command.CommandText = "sp_sel_Processo";
                    command.Parameters.AddWithValue("@ID_PROCESSO", Id);
                    command.Parameters.AddWithValue("@MODULO", Modulo);
                    await connection.OpenAsync();
                    using (var reader = await command.ExecuteReaderAsync())
                    {
                        if (await reader.ReadAsync())
                        {
                            processo = new Processo();
                            processo.Id = !reader.IsDBNull(0) ? reader.GetInt32(0) : processo.Id;
                            processo.Nome = !reader.IsDBNull(1) ? reader.GetString(0) : processo.Nome;
                            processo.Descricao = !reader.IsDBNull(2) ? reader.GetString(2) : processo.Descricao;
                            processo.Ativo = !reader.IsDBNull(3) ? reader.GetBoolean(3) : processo.Ativo;
                            processo.Data = !reader.IsDBNull(4) ? reader.GetDateTime(4) : processo.Data;
                            processo.Regulamento = !reader.IsDBNull(5) ? reader.GetString(5) : processo.Regulamento;
                            processo.DataInicio = !reader.IsDBNull(6) ? reader.GetDateTime(6) : processo.DataInicio;
                            processo.DataTermino = !reader.IsDBNull(7) ? reader.GetDateTime(7) : processo.DataTermino;
                            processo.BloquearEstacao = !reader.IsDBNull(8) ? reader.GetBoolean(8) : processo.BloquearEstacao;
                            processo.Perfil = !reader.IsDBNull(9) ? reader.GetString(9) : processo.Perfil;
                        }
                        reader.Close();
                        connection.Close();
                        return processo;
                    }
                }
            }
        }

        public async Task Aceite(string CPF, int ProcessoId)
        {
            string computador = Environment.MachineName;
            using (var connection = new System.Data.SqlClient.SqlConnection(this.ConnectionString))
            {
                using (var command = connection.CreateCommand())
                {
                    command.CommandType = System.Data.CommandType.StoredProcedure;
                    command.CommandText = "sp_INS_ACEITE";
                    command.Parameters.AddWithValue("@CPF_USUARIO", CPF);
                    command.Parameters.AddWithValue("@ID_PROCESSO", ProcessoId);
                    await connection.OpenAsync();
                    int r = await command.ExecuteNonQueryAsync();
                    connection.Close();
                }
            }
        }
        public async Task Usuario(string CPF, string Nome, string DomainName, string Email, string Ramal)
        {
            using (var connection = new System.Data.SqlClient.SqlConnection(this.ConnectionString))
            {
                using (var command = connection.CreateCommand())
                {
                    command.CommandType = System.Data.CommandType.StoredProcedure;
                    command.CommandText = "sp_INS_USUARIO";
                    command.Parameters.AddWithValue("@CPF_USUARIO", CPF);
                    command.Parameters.AddWithValue("@NM_USUARIO", Nome);
                    command.Parameters.AddWithValue("@DM_USUARIO", DomainName);
                    command.Parameters.AddWithValue("@EMAIL_USUARIO", Email);
                    command.Parameters.AddWithValue("@RAMAL_USUARIO", Ramal);
                    await connection.OpenAsync();
                    int r = await command.ExecuteNonQueryAsync();
                    connection.Close();
                }
            }
        }
        public async Task Acesso(string CPF, int ProcessoId)
        {
            string computador = Environment.MachineName;
            using (var connection = new System.Data.SqlClient.SqlConnection(this.ConnectionString))
            {
                using (var command = connection.CreateCommand())
                {
                    command.CommandType = System.Data.CommandType.StoredProcedure;
                    command.CommandText = "sp_INS_LogAcesso";
                    command.Parameters.AddWithValue("@CPF_USUARIO", CPF);
                    command.Parameters.AddWithValue("@ID_PROCESSO", ProcessoId);
                    await connection.OpenAsync();
                    int r = await command.ExecuteNonQueryAsync();
                    connection.Close();
                }
            }
        }

        public async Task<string> Titulo()
        {
            return await RecuperaDoBanco("PSTI-TITULO");
        }
        public async Task<string> Descricao()
        {
            return await RecuperaDoBanco("PSTI-DESCRICAO");
        }
        public async Task<string> Regulamento()
        {
            return await RecuperaDoBanco("PSTI-REGULAMENTO");
        }

        private async Task<string> RecuperaDoBanco(string codigo)
        {
            string retorno = null;
            using (var connection = new System.Data.SqlClient.SqlConnection(this.ConnectionString))
            {
                using (var command = connection.CreateCommand())
                {
                    command.CommandType = System.Data.CommandType.StoredProcedure;
                    command.CommandText = "sp_sel_TEXTOS_ACEITE";
                    command.Parameters.AddWithValue("@TEXTO_COD", codigo);
                    await connection.OpenAsync();
                    using (var reader = await command.ExecuteReaderAsync())
                    {
                        if (await reader.ReadAsync())
                        {
                            retorno = reader.GetString(0);
                        }
                        reader.Close();
                        connection.Close();

                        return retorno;
                    }
                }
            }
        }

        public void Dispose() { }
    }
}