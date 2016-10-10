using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using iTextSharp.text.pdf;

public static async Task<HttpResponseMessage> Run(HttpRequestMessage req, TraceWriter log)
{
    log.Info($"C# HTTP trigger function processed a request. RequestUri={req.RequestUri}");

    // parse query parameter
    string name = req.GetQueryNameValuePairs()
        .FirstOrDefault(q => string.Compare(q.Key, "name", true) == 0)
        .Value;

    // Get request body
    dynamic data = await req.Content.ReadAsAsync<object>();

    // Set name to query string or body data
    name = name ?? data?.name;

    if (name == null) return req.CreateResponse(HttpStatusCode.BadRequest, "Please pass a name on the query string or in the request body");

    var pdfReader = new PdfReader(@"d:\home\site\wwwroot\HttpTriggerCSharp1\AccountCard.pdf");
    var stream = new MemoryStream();
    var pdfStamper = new PdfStamper(pdfReader, stream);
    pdfStamper.AcroFields.SetField(
            "concat(//FirstName, ' ', //MiddleInitial, ' ', //LastName, ' ', //Suffix)", name);
    pdfStamper.Close();
    byte[] bytes = stream.ToArray();

    var response = new HttpResponseMessage();
    response.StatusCode = HttpStatusCode.OK;
    response.Headers.Clear();
    response.Headers.CacheControl = new CacheControlHeaderValue {Private = true};
    response.Content = new ByteArrayContent(bytes);
    response.Content.Headers.ContentType = new MediaTypeHeaderValue("application/pdf");
    response.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment")
    {
        FileName = "Forms.pdf"
    };

    return response;
}
