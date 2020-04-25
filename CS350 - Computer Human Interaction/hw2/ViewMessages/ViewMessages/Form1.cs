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
using System.Timers;

namespace ViewMessages
{
    public partial class Form1 : Form
    {

        private string filePath = "D:\\Users\\gmatt\\Documents\\messages";
        Message[] messages = { };
        int currMsg = 0;
        private delegate void SafeCallDelegate();
        System.Timers.Timer tmr;  // timer object

        public Form1()
        {
            InitializeComponent();
            string[] files = Directory.GetFiles(filePath);
            foreach (string file in files)
            {
                string text = File.ReadAllText(file);
                string[] spearator = { "----------------------" };
                string[] split = text.Split(spearator, 3, StringSplitOptions.RemoveEmptyEntries);
                if (split.Length == 3)
                {
                    pushNewMessage(file, split[0], split[1], split[2]);
                }
            }
            tmr = new System.Timers.Timer(5000);  // 5 seconds
            tmr.Elapsed += new ElapsedEventHandler(getMessages);
            tmr.Start();
        }

        void pushNewMessage(string filename, string name, string subject, string message)
        {
            Array.Resize(ref messages, messages.Length + 1);
            messages[messages.GetUpperBound(0)] = new Message(filename, name, subject, message);
        }

        private void getMessages(object sender, ElapsedEventArgs e)
        {
            string[] files = Directory.GetFiles(filePath);
            if (files.Length != messages.Length)
            {
                MessageBox.Show("New message received!");
                foreach (string file in files)
                {
                    if (!containsFile(file))
                    {
                        string text = File.ReadAllText(file);
                        string[] spearator = { "----------------------" };
                        string[] split = text.Split(spearator, 3, StringSplitOptions.RemoveEmptyEntries);
                        if (split.Length == 3)
                        {
                            pushNewMessage(file, split[0], split[1], split[2]);
                        }
                    }
                }
            }
        }

        private bool containsFile(string file)
        {
            foreach (Message message in messages)
            {
                if (message.getFilename() == file)
                {
                    return true;
                }
            }
            return false;
        }

        private void setTextBox()
        {
            string message = "Name" + Environment.NewLine + messages[currMsg].getName() + Environment.NewLine + Environment.NewLine;
            message += "Subject" + Environment.NewLine + messages[currMsg].getSubject() + Environment.NewLine + Environment.NewLine;
            message += "Message" + Environment.NewLine + messages[currMsg].getMessage();
            if (textBox.InvokeRequired)
            {
                var d = new SafeCallDelegate(setTextBox);
                textBox.Invoke(d, new object[] { message });
            }
            else
            {
                textBox.Text = message;
            }
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            if (messages.Length > 0)
            {
                setTextBox();
            }
            else
            {
                textBox.Text = "No messages found!";
            }
        }

        private void nextBtn_Click(object sender, EventArgs e)
        {
            if (messages.Length > 0)
            {
                if (currMsg == (messages.Length - 1))
                {
                    currMsg = 0;
                }
                else
                {
                    currMsg++;
                }
                setTextBox();
            }
            else
            {
                MessageBox.Show("No messagess to show!");
            }
        }

        private void prevBtn_Click(object sender, EventArgs e)
        {
            if (messages.Length > 0)
            {
                if (currMsg == 0)
                {
                    currMsg = messages.Length - 1;
                }
                else
                {
                    currMsg--;
                }
                setTextBox();
            } 
            else
            {
                MessageBox.Show("No messagess to show!");
            }
        }
    }

    class Message
    {
        string name;
        string subject;
        string message;
        string filename;
        public Message(string filename, string name, string subject, string message)
        {
            this.name = name;
            this.subject = subject;
            this.message = message;
            this.filename = filename;
        }

        public string getName() { return name; }
        public string getSubject() { return subject; }
        public string getMessage() { return message; }
        public string getFilename() { return filename; }
    }
}
