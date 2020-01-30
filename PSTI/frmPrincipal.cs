using PSTI.Library.Application;
using PSTI.Library.Domain;
using System;
using System.Diagnostics;
using System.Drawing;
using System.Net;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace PSTI
{
    public partial class frmPrincipal : Form
    {
        private bool fechar = false;
        private frmMonitorSecundario frm;
        private Usuario usuario;
        private Processo processo;

        #region | Desabilitando menu iniciar - teclas de atalho
        [DllImport("user32.dll")]
        private static extern int GetWindowText(IntPtr hWnd, StringBuilder text, int count);

        [DllImport("user32.dll", CharSet = CharSet.Auto)]
        private static extern bool EnumThreadWindows(int threadId, EnumThreadProc pfnEnum, IntPtr lParam);

        [DllImport("user32.dll", SetLastError = true)]
        private static extern System.IntPtr FindWindow(string lpClassName, string lpWindowName);

        [DllImport("user32.dll", SetLastError = true)]
        private static extern IntPtr FindWindowEx(IntPtr parentHandle, IntPtr childAfter, string className, string windowTitle);

        [DllImport("user32.dll")]
        private static extern int ShowWindow(IntPtr hwnd, int nCmdShow);

        [DllImport("user32.dll")]
        private static extern uint GetWindowThreadProcessId(IntPtr hwnd, out int lpdwProcessId);

        private const int SW_HIDE = 0;
        private const int SW_SHOW = 5;

        private const string VistaStartMenuCaption = "Start";
        private static IntPtr vistaStartMenuWnd = IntPtr.Zero;
        private delegate bool EnumThreadProc(IntPtr hwnd, IntPtr lParam);

        // Structure contain information about low-level keyboard input event
        [StructLayout(LayoutKind.Sequential)]
        private struct KBDLLHOOKSTRUCT
        {
            public Keys key;
            public int scanCode;
            public int flags;
            public int time;
            public IntPtr extra;
        }

        public frmPrincipal()
        {
            //Get Current Module
            ProcessModule objCurrentModule = Process.GetCurrentProcess().MainModule;
            //Assign callback function each time keyboard process
            objKeyboardProcess = new LowLevelKeyboardProc(captureKey);
            //Setting Hook of Keyboard Process for current module
            ptrHook = SetWindowsHookEx(13, objKeyboardProcess, GetModuleHandle(objCurrentModule.ModuleName), 0);
            //inicializando componentes
            InitializeComponent();
        }
        //Declaring Global objects
        private IntPtr ptrHook;
        private LowLevelKeyboardProc objKeyboardProcess;
        //capturando as teclas de atalho
        private IntPtr captureKey(int nCode, IntPtr wp, IntPtr lp)
        {
            if (nCode >= 0)
            {
                KBDLLHOOKSTRUCT objKeyInfo = (KBDLLHOOKSTRUCT)Marshal.PtrToStructure(lp, typeof(KBDLLHOOKSTRUCT));

                if (objKeyInfo.key == Keys.RWin || objKeyInfo.key == Keys.LWin) // Disabling Windows keys
                {
                    return (IntPtr)1;
                }
                if (objKeyInfo.key == Keys.Control || objKeyInfo.key == Keys.Alt || objKeyInfo.key == Keys.Delete)
                {
                    return (IntPtr)1;
                }
            }
            return CallNextHookEx(ptrHook, nCode, wp, lp);
        }
        //removendo o controle de teclas de atalho
        protected override void DestroyHandle()
        {
            if (components != null)
            {
                components.Dispose();
            }
            if (ptrHook != IntPtr.Zero)
            {
                UnhookWindowsHookEx(ptrHook);
                ptrHook = IntPtr.Zero;
            }
            base.DestroyHandle();
        }
        #endregion

        #region | Desabilitando menu iniciar e barra de tarefas
        //System level functions to be used for hook and unhook keyboard input
        private delegate IntPtr LowLevelKeyboardProc(int nCode, IntPtr wParam, IntPtr lParam);
        [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
        private static extern IntPtr SetWindowsHookEx(int id, LowLevelKeyboardProc callback, IntPtr hMod, uint dwThreadId);
        [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
        private static extern bool UnhookWindowsHookEx(IntPtr hook);
        [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
        private static extern IntPtr CallNextHookEx(IntPtr hook, int nCode, IntPtr wp, IntPtr lp);
        [DllImport("kernel32.dll", CharSet = CharSet.Auto, SetLastError = true)]
        private static extern IntPtr GetModuleHandle(string name);
        [DllImport("user32.dll", CharSet = CharSet.Auto)]
        private static extern short GetAsyncKeyState(Keys key);
        /// <summary>
        /// Show the taskbar.
        /// </summary>
        public static void Show()
        {
            SetVisibility(true);
        }

        /// <summary>
        /// Hide the taskbar.
        /// </summary>
        public static void Hide()
        {
            SetVisibility(false);
        }

        /// <summary>
        /// Sets the visibility of the taskbar.
        /// </summary>
        public static bool Visible
        {
            set { SetVisibility(value); }
        }

        /// <summary>
        /// Hide or show the Windows taskbar and startmenu.
        /// </summary>
        /// <param name="show">true to show, false to hide</param>
        private static void SetVisibility(bool show)
        {
            // get taskbar window
            IntPtr taskBarWnd = FindWindow("Shell_TrayWnd", null);

            // try it the WinXP way first...
            IntPtr startWnd = FindWindowEx(taskBarWnd, IntPtr.Zero, "Button", "Start");
            if (startWnd == IntPtr.Zero)
            {
                // ok, let's try the Vista easy way...
                startWnd = FindWindow("Button", null);

                if (startWnd == IntPtr.Zero)
                {
                    // no chance, we need to to it the hard way...
                    startWnd = GetVistaStartMenuWnd(taskBarWnd);
                }
            }

            ShowWindow(taskBarWnd, show ? SW_SHOW : SW_HIDE);
            ShowWindow(startWnd, show ? SW_SHOW : SW_HIDE);
        }

        /// <summary>
        /// Returns the window handle of the Vista start menu orb.
        /// </summary>
        /// <param name="taskBarWnd">windo handle of taskbar</param>
        /// <returns>window handle of start menu</returns>
        private static IntPtr GetVistaStartMenuWnd(IntPtr taskBarWnd)
        {
            // get process that owns the taskbar window
            int procId;
            GetWindowThreadProcessId(taskBarWnd, out procId);

            Process p = Process.GetProcessById(procId);
            if (p != null)
            {
                // enumerate all threads of that process...
                foreach (ProcessThread t in p.Threads)
                {
                    EnumThreadWindows(t.Id, MyEnumThreadWindowsProc, IntPtr.Zero);
                }
            }
            return vistaStartMenuWnd;
        }

        /// <summary>
        /// Callback method that is called from 'EnumThreadWindows' in 'GetVistaStartMenuWnd'.
        /// </summary>
        /// <param name="hWnd">window handle</param>
        /// <param name="lParam">parameter</param>
        /// <returns>true to continue enumeration, false to stop it</returns>
        private static bool MyEnumThreadWindowsProc(IntPtr hWnd, IntPtr lParam)
        {
            StringBuilder buffer = new StringBuilder(256);
            if (GetWindowText(hWnd, buffer, buffer.Capacity) > 0)
            {
                Console.WriteLine(buffer);
                if (buffer.ToString() == VistaStartMenuCaption)
                {
                    vistaStartMenuWnd = hWnd;
                    return false;
                }
            }
            return true;
        }
        #endregion

        #region | Carregando formulário do segundo monitor
        public Screen GetSecondaryScreen()
        {
            if (Screen.AllScreens.Length == 1)
            {
                return null;
            }

            foreach (Screen screen in Screen.AllScreens)
            {
                if (screen.Primary == false)
                {
                    return screen;
                }
            }

            return null;
        }
        private void SegundoMonitor()
        {
            Screen screen = GetSecondaryScreen();
            if (screen != null)
            {
                frm = new frmMonitorSecundario();
                frm.StartPosition = FormStartPosition.Manual;
                frm.Location = screen.WorkingArea.Location;
                frm.FormBorderStyle = FormBorderStyle.None;
                frm.WindowState = FormWindowState.Maximized;
                frm.TopMost = true;
                frm.Size = new Size(screen.WorkingArea.Width, screen.WorkingArea.Height);
                frm.Show();
            }
        }
        #endregion

        #region | Recuperação dos textos do formulário
        private async Task RecuperaTextos()
        {
            string descricao, regulamento;
            using (var data = new Dados())
            {
                processo = await data.Processo();
                data.ConnectionString = "Server=(local);Database=RH-FDE;User Id=sa;Password=P@ssw0rd;";
                lblTitulo.Text = await data.Titulo();
                descricao = await data.Descricao();
                regulamento = await data.Regulamento();
            }
            //fazendo download da descricao
            await RecuperaTextos(descricao, "descricao.rtf", richTextBoxDescricao);

            //fazendo download do regulamento
            await RecuperaTextos(regulamento, "regulamento.rtf", richTextBoxRegulamento);
        }
        private async Task RecuperaTextos(string url, string fileName, RichTextBox rich)
        {
            //fazendo download do regulamento
            using (WebClient cliente = new WebClient())
            {
                try
                {
                    cliente.UseDefaultCredentials = true;
                    var uri = new Uri(url);
                    var path = System.Environment.GetFolderPath(System.Environment.SpecialFolder.Personal) + @"\" + fileName;
                    await cliente.DownloadFileTaskAsync(uri, path);
                    rich.LoadFile(path);
                }
                catch (Exception ex)
                {
                    string error = ex.Message;
                }
            }
        }
        #endregion

        #region | Registra visita
        private async Task RegistraVisita()
        {
            try
            {
                using (var data = new Dados())
                {
                    await data.Usuario(usuario.CPF, usuario.Nome, usuario.NomeDeDominio, usuario.Email, usuario.Telefone);
                    await data.Acesso(usuario.CPF, processo.Id);
                }
            }
            catch (Exception ex)
            {
                string error = ex.Message;
            }
        }
        #endregion

        #region | Eventos do formulário
        private void ConfiguraFormulario()
        {
            FormBorderStyle = FormBorderStyle.None;
            WindowState = FormWindowState.Maximized;
            TopMost = true;
            this.panel1.Location = new Point(this.ClientSize.Width / 2 - this.panel1.Size.Width / 2, this.ClientSize.Height / 2 - this.panel1.Size.Height / 2);
            this.panel1.Anchor = AnchorStyles.None;
            this.timer1.Start();
        }
        private async void frmPrincipal_Load(object sender, EventArgs e)
        {
            usuario = UsuariosAD.GetUsuario();

            ConfiguraFormulario();

            await RecuperaTextos();

            //SegundoMonitor();

            Hide();
            
            await RegistraVisita();
        }

        private void frmPrincipal_FormClosed(object sender, FormClosedEventArgs e)
        {
            Show();
        }
        private void frmPrincipal_FormClosing(object sender, FormClosingEventArgs e)
        {
            if (!this.fechar)
            {
                e.Cancel = true;
                return;
            }

            var closeMsg = MessageBox.Show("Você realmente deseja fechar essa janela?", "Atenção", MessageBoxButtons.YesNo, MessageBoxIcon.Question);

            if (closeMsg == DialogResult.Yes)
            {
                e.Cancel = false;
            }
            else
            {
                e.Cancel = true;
            }
        }
        private void button1_Click(object sender, EventArgs e)
        {
            if (this.frm != null && this.frm.timer1 != null)
                this.frm.timer1.Stop();
            this.timer1.Stop();
            this.fechar = true;
            this.Close();
            Application.Exit();
        }
        private void timer1_Tick(object sender, EventArgs e)
        {
            this.BringToFront();
        }
        private void frmPrincipal_Deactivate(object sender, EventArgs e)
        {
            this.Activate();
        }
        private void button2_Click(object sender, EventArgs e)
        {
            // Create an OpenFileDialog to request a file to open.
            OpenFileDialog openFile1 = new OpenFileDialog();

            // Initialize the OpenFileDialog to look for RTF files.
            openFile1.DefaultExt = "*.rtf";
            openFile1.Filter = "RTF Files|*.rtf";

            // Determine whether the user selected a file from the OpenFileDialog.
            if (openFile1.ShowDialog() == System.Windows.Forms.DialogResult.OK &&
               openFile1.FileName.Length > 0)
            {
                // Load the contents of the file into the RichTextBox.
                richTextBoxRegulamento.LoadFile(openFile1.FileName);
            }
        }
        #endregion
    }
}
