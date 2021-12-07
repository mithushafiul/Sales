using CrystalDecisions.CrystalReports.Engine;
using SALESMVC.Models;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace SALESMVC.Controllers
{
    public class HomeController : Controller
    {

        public static DataTable dtTable;
        public static string connectionString = ConfigurationSettings.AppSettings["ConnectionString"];
        public SqlConnection conn = new SqlConnection(connectionString);
        public SqlDataAdapter SqlDataAdapter = new SqlDataAdapter();

        SALESDBEntities db = new SALESDBEntities();
        public ActionResult SaleList()
        {
            return View(db.SALES.ToList());
        }
       
        public ActionResult SalePurchase(string SearchString)
        {
            string query = "";
            string ITEM_NAME = SearchString;
            DataSet ds = new DataSet();

            query = ("EXEC [SALE_PURCHASE] @ITEM_NAME='" + ITEM_NAME + "' ");
            SqlConnection conn = new SqlConnection(connectionString);
            SqlCommand comm = new SqlCommand(query, conn);            
            try
            {
                conn.Open();
                comm.CommandType = CommandType.Text;
                SqlDataAdapter sda = new SqlDataAdapter(comm);
                sda.Fill(ds);
            }
            catch (Exception ex)
            {

            }
            finally
            {
                conn.Close();
            }            
               
            return View(ds);            
        }


        public ActionResult exportReport(string SearchString)
        {
            string query = "";
            string ITEM_NAME = SearchString;

            query = ("[dbo].SALE_PURCHASE @ITEM_NAME='" + ITEM_NAME + "'");
            SqlConnection conn = new SqlConnection(connectionString);
            SqlCommand comm = new SqlCommand(query, conn);
            SalePurchase sapu = new SalePurchase();               
            DataSet ds = new DataSet();
            try
            {
                conn.Open();
                comm.CommandType = CommandType.Text;
                SqlDataAdapter sda = new SqlDataAdapter(comm);
                sda.Fill(ds);
            }
            catch (Exception ex)
            {
                   
            }
            finally
            {
            }           

            ReportDocument rd = new ReportDocument();
            rd.Load(Path.Combine(Server.MapPath("~/Report"), "SalePurchaseReport.rpt"));

            rd.SetDataSource(ds.Tables[0]);

            Response.Buffer = false;
            Response.ClearContent();
            Response.ClearHeaders();

            try
            {
                Stream stream = rd.ExportToStream(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat);
                stream.Seek(0, SeekOrigin.Begin);
                return File(stream, "application/pdf");
            }

            catch
            {
                throw;
            }
        }  
    }
}