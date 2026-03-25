/**
 * Google Apps Script — Email Sender Web App
 * ==========================================
 * SETUP INSTRUCTIONS:
 *
 * 1. Go to https://script.google.com and create a new project (name it "AlgaeDB Email").
 * 2. Delete the default code and paste ALL of the code below.
 * 3. Click "Deploy" → "New deployment".
 * 4. Choose type: "Web app".
 * 5. Set "Execute as": Me (your Google account).
 * 6. Set "Who has access": Anyone.
 * 7. Click "Deploy" and authorize permissions when prompted.
 * 8. Copy the Web App URL shown after deployment.
 * 9. Set that URL as the environment variable APPS_SCRIPT_EMAIL_URL on Render.
 *
 * The Java EmailService will POST JSON {"to":"...","subject":"...","html":"..."} to this URL.
 */

function doPost(e) {
  try {
    var data = JSON.parse(e.postData.contents);

    var to      = data.to;
    var subject = data.subject;
    var html    = data.html;

    if (!to || !subject || !html) {
      return ContentService
        .createTextOutput(JSON.stringify({ status: "error", message: "Missing fields: to, subject, or html" }))
        .setMimeType(ContentService.MimeType.JSON);
    }

    MailApp.sendEmail({
      to:       to,
      subject:  subject,
      htmlBody: html
    });

    return ContentService
      .createTextOutput(JSON.stringify({ status: "ok" }))
      .setMimeType(ContentService.MimeType.JSON);

  } catch (err) {
    return ContentService
      .createTextOutput(JSON.stringify({ status: "error", message: err.toString() }))
      .setMimeType(ContentService.MimeType.JSON);
  }
}

// Optional: test from the Apps Script editor (Run → doGet)
function doGet(e) {
  return ContentService
    .createTextOutput("AlgaeDB Email Service is running.")
    .setMimeType(ContentService.MimeType.TEXT);
}
