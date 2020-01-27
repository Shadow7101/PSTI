using System;
using System.Windows.Forms;

namespace PSTI
{
    public partial class frmMonitorSecundario : Form
    {
        public frmMonitorSecundario()
        {
            InitializeComponent();
        }

        private void timer1_Tick(object sender, EventArgs e)
        {
            this.BringToFront();
        }

        private void frmMonitorSecundario_Load(object sender, EventArgs e)
        {
            this.timer1.Start();
        }

        private void frmMonitorSecundario_FormClosing(object sender, FormClosingEventArgs e)
        {
            e.Cancel = true;
        }
    }
}
