using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.IO;

namespace MessageApp
{
    public partial class Form1 : Form
    {

        private string filePath = "D:\\Users\\gmatt\\Documents\\messages";

        public Form1()
        {
            InitializeComponent();
        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }

        private void submitBtn_Click(object sender, EventArgs e)
        {
            string errorStr = "ERROR" + Environment.NewLine;
            if (nameBox.TextLength == 0) 
            {
                errorStr += "- Name is empty" + Environment.NewLine;
            }
            if (subjectBox.TextLength == 0)
            {
                errorStr += "- Subject is empty" + Environment.NewLine;
            }
            if (msgBox.TextLength == 0)
            {
                errorStr += "- Message is empty" + Environment.NewLine;
            }
            if (errorStr != "ERROR" + Environment.NewLine)
            {
                MessageBox.Show(errorStr);
            } 
            else
            {
                string timestamp = DateTime.Now.ToString("yyyy-MM-ddTHHmmss");
                string fileName = filePath + "\\" + timestamp + ".txt";

                StreamWriter fileOutput = new StreamWriter(fileName, true);
                fileOutput.WriteLine(nameBox.Text);
                fileOutput.WriteLine("----------------------");
                fileOutput.WriteLine(subjectBox.Text);
                fileOutput.WriteLine("----------------------");
                fileOutput.WriteLine(msgBox.Text);
                fileOutput.Close();
                MessageBox.Show("Message saved!");
                nameBox.Text = "";
                subjectBox.Text = "";
                msgBox.Text = "";
            }

        }

        private void button1_Click(object sender, EventArgs e)
        {
            nameBox.Text = "";
            subjectBox.Text = "";
            msgBox.Text = "";
        }
    }
}
