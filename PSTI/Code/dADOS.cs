using System;
using System.Threading.Tasks;

namespace PSTI.Code
{
    public class Dados : IDisposable
    {
        private readonly string ConnectionString;

        public Dados()
        {
            string conexaoCriptografada = System.Configuration.ConfigurationManager.AppSettings["PSTI-CON"];
            var c = new Criptografia();
            this.ConnectionString = c.Decriptografa(conexaoCriptografada);
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