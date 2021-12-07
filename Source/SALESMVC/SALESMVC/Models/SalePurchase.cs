using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SALESMVC.Models
{
    public class SalePurchase
    {
       public string  INVOICE_NO {get;set;}
       public DateTime ENTRY_DATE { get; set; }
       public string ITEM_NAME { get; set; }
       public decimal SALES_PRICE { get; set; }
       public decimal PURCHASE_PRICE { get; set; }
       public decimal PROFIT { get; set; }
        
    }
}