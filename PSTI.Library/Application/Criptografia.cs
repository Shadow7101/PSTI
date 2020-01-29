﻿/*
 Desenvolvido Por: Emerson Shigueo Sugimoto
 Data: 23/03/2013 05:27 - Curitiba, Brasil [-25.4320914,-49.2683035]
 E-mail: eme.vbnet[at]gmail.com
 
https://emersonbsi.wordpress.com/2013/03/23/criptografia-em-c/

*/
using System;
using System.Text;
using System.IO;
using System.Security.Cryptography;

namespace PSTI.Library.Application
{
    public enum CryptProvider
    {
        /// <summary>
        /// algoritmos simétricos Rijndael
        /// </summary>
        Rijndael,
        RC2,
        /// <summary>
        /// DES - Data Encryption Standard
        /// </summary>
        DES,
        /// <summary>
        /// TripleDES - Triple Data Encryption Standard
        /// </summary>
        TripleDES
    }

    public class Cript
    {
        #region Propriedades
        private string _key = string.Empty;
        private CryptProvider _cryptProvider;
        private SymmetricAlgorithm _algorithm;

        /// <summary>
        /// Chave secreta para o algoritmo simétrico de criptografia.
        /// </summary>
        public string Key { get { return _key; } set { _key = value; } }
        #endregion

        #region Construtor
        public Cript(CryptProvider cryptProvider = CryptProvider.Rijndael)
        {
            switch (cryptProvider)
            {
                case CryptProvider.Rijndael:
                    _algorithm = new RijndaelManaged();
                    _cryptProvider = CryptProvider.Rijndael;
                    break;
                case CryptProvider.RC2:
                    _algorithm = new RC2CryptoServiceProvider();
                    _cryptProvider = CryptProvider.RC2;
                    break;
                case CryptProvider.DES:
                    _algorithm = new DESCryptoServiceProvider();
                    _cryptProvider = CryptProvider.DES;
                    break;
                case CryptProvider.TripleDES:
                    _algorithm = new TripleDESCryptoServiceProvider();
                    _cryptProvider = CryptProvider.TripleDES;
                    break;
            }
            _algorithm.Mode = CipherMode.CBC;
        }
        #endregion

        #region Publico
        /// <summary>
        /// Gera a chave de criptografia válida dentro do array.
        /// </summary>
        /// <returns>Chave com array de bytes.</returns>
        public virtual byte[] GetKey()
        {
            string salt = string.Empty;

            // Ajuta o tamanho da chave se necessário e retorna uma chave válida
            if (_algorithm.LegalKeySizes.Length > 0)
            {
                // Tamanho das chaves em bits
                int keySize = _key.Length * 8;
                int minSize = _algorithm.LegalKeySizes[0].MinSize;
                int maxSize = _algorithm.LegalKeySizes[0].MaxSize;
                int skipSize = _algorithm.LegalKeySizes[0].SkipSize;

                if (keySize > maxSize)
                {
                    // Busca o valor máximo da chave
                    _key = _key.Substring(0, maxSize / 8);
                }
                else if (keySize < maxSize)
                {
                    // Seta um tamanho válido
                    int validSize = (keySize <= minSize) ? minSize : (keySize - keySize % skipSize) + skipSize;
                    if (keySize < validSize)
                    {
                        // Preenche a chave com arterisco para corrigir o tamanho
                        _key = _key.PadRight(validSize / 8, '*');
                    }
                }
            }
            PasswordDeriveBytes key = new PasswordDeriveBytes(_key, ASCIIEncoding.ASCII.GetBytes(salt));
            return key.GetBytes(_key.Length);
        }
        /// <summary>
        /// Encripta o dado solicitado.
        /// </summary>
        /// <param name="plainText">Texto a ser criptografado.</param>
        /// <returns>Texto criptografado.</returns>
        public virtual string Encrypt(string plainText)
        {
            byte[] plainByte = ASCIIEncoding.ASCII.GetBytes(plainText);
            byte[] keyByte = GetKey();

            // Seta a chave privada
            _algorithm.Key = keyByte;
            SetIV();

            // Interface de criptografia / Cria objeto de criptografia
            ICryptoTransform cryptoTransform = _algorithm.CreateEncryptor();

            MemoryStream _memoryStream = new MemoryStream();

            CryptoStream _cryptoStream = new CryptoStream(_memoryStream, cryptoTransform, CryptoStreamMode.Write);

            // Grava os dados criptografados no MemoryStream
            _cryptoStream.Write(plainByte, 0, plainByte.Length);
            _cryptoStream.FlushFinalBlock();

            // Busca o tamanho dos bytes encriptados
            byte[] cryptoByte = _memoryStream.ToArray();

            // Converte para a base 64 string para uso posterior em um xml
            return Convert.ToBase64String(cryptoByte, 0, cryptoByte.GetLength(0));
        }
        /// <summary>
        /// Desencripta o dado solicitado.
        /// </summary>
        /// <param name="cryptoText">Texto a ser descriptografado.</param>
        /// <returns>Texto descriptografado.</returns>
        public virtual string Decrypt(string cryptoText)
        {
            // Converte a base 64 string em num array de bytes
            byte[] cryptoByte = Convert.FromBase64String(cryptoText);
            byte[] keyByte = GetKey();

            // Seta a chave privada
            _algorithm.Key = keyByte;
            SetIV();

            // Interface de criptografia / Cria objeto de descriptografia
            ICryptoTransform cryptoTransform = _algorithm.CreateDecryptor();
            try
            {
                MemoryStream _memoryStream = new MemoryStream(cryptoByte, 0, cryptoByte.Length);

                CryptoStream _cryptoStream = new CryptoStream(_memoryStream, cryptoTransform, CryptoStreamMode.Read);

                // Busca resultado do CryptoStream
                StreamReader _streamReader = new StreamReader(_cryptoStream);
                return _streamReader.ReadToEnd();
            }
            catch
            {
                return null;
            }
        }
        #endregion

        #region Privado
        private void SetIV()
        {
            switch (_cryptProvider)
            {
                case CryptProvider.Rijndael:
                    _algorithm.IV = new byte[] { 0xf, 0x6f, 0x13, 0x2e, 0x35, 0xc2, 0xcd, 0xf9, 0x5, 0x46, 0x9c, 0xea, 0xa8, 0x4b, 0x73, 0xcc };
                    break;
                default:
                    _algorithm.IV = new byte[] { 0xf, 0x6f, 0x13, 0x2e, 0x35, 0xc2, 0xcd, 0xf9 };
                    break;
            }
        }
        #endregion

    }
    public class Criptografia
    {
        private readonly string _chave;

        public Criptografia()
        {
            this._chave = System.Configuration.ConfigurationManager.AppSettings["PSTI-KEY"];
        }

        public string Criptografa(string cChave)
        {
            string cChaveCripto;
            Byte[] b = System.Text.ASCIIEncoding.ASCII.GetBytes(cChave);
            cChaveCripto = Convert.ToBase64String(b);
            return cChaveCripto;
        }

        public string Decriptografa(string cChaveCripto)
        {
            string cChaveDecripto;
            Byte[] b = Convert.FromBase64String(cChaveCripto);
            cChaveDecripto = System.Text.ASCIIEncoding.ASCII.GetString(b);
            return cChaveDecripto;
        }
    }
}