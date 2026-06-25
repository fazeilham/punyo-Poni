ini merupakan code dari apps script saya
// ======================================================
// GOOGLE APPS SCRIPT - FINAL VERSION (ANTI-GAGAL)
// Backend Flutter + Google Spreadsheet
// ======================================================

const SHEET_ADMIN = "Admin";
const SHEET_CUSTOMER = "Customer";
const SHEET_PRODUCT = "Product";
const SHEET_KERANJANG = "Keranjang";
const SHEET_PESANAN = "Pesanan";
const SHEET_TRANSAKSI = "Transaksi";

// =========================
// GET
// =========================
function doGet(e) {
try {
if (!e.parameter.action) {
return jsonResponse({ status: false, message: "Parameter action tidak ditemukan." });
}

    switch (e.parameter.action) {
      case "getAdmin": return getAll(SHEET_ADMIN);
      case "getCustomer": return getAll(SHEET_CUSTOMER);
      case "getProduct": return getAll(SHEET_PRODUCT);
      case "getKeranjang": return getAll(SHEET_KERANJANG);
      case "getPesanan": return getAll(SHEET_PESANAN);
      case "getTransaksi": return getAll(SHEET_TRANSAKSI);
      default:
        return jsonResponse({ status: false, message: "GET Action tidak ditemukan." });
    }

} catch (err) {
return jsonResponse({ status: false, message: err.toString() });
}
}

// =========================
// POST
// =========================
function doPost(e) {
try {
if (!e.postData || !e.postData.contents) {
return jsonResponse({ status: false, message: "Data POST kosong." });
}

    var data = JSON.parse(e.postData.contents);

    if (!data.action) {
      return jsonResponse({ status: false, message: "Action belum dikirim." });
    }

    switch (data.action) {
      case "loginAdmin": return loginAdmin(data);
      case "insertCustomer": return insertRow(SHEET_CUSTOMER, data);
      case "insertProduct": return insertRow(SHEET_PRODUCT, data);
      case "insertKeranjang": return insertRow(SHEET_KERANJANG, data);
      case "insertPesanan": return insertRow(SHEET_PESANAN, data);
      case "insertTransaksi": return insertRow(SHEET_TRANSAKSI, data);
      case "updateCustomer": return updateRow(SHEET_CUSTOMER, data);
      case "updateProduct": return updateRow(SHEET_PRODUCT, data);
      case "deleteCustomer": return deleteRow(SHEET_CUSTOMER, data);
      case "deleteProduct": return deleteRow(SHEET_PRODUCT, data);
      default:
        return jsonResponse({ status: false, message: "POST Action tidak ditemukan." });
    }

} catch (err) {
return jsonResponse({ status: false, message: err.toString() });
}
}

function jsonResponse(data) {
return ContentService.createTextOutput(JSON.stringify(data)).setMimeType(ContentService.MimeType.JSON);
}

function getSheet(sheetName) {
var sheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName(sheetName);
if (!sheet) { throw new Error("Sheet " + sheetName + " tidak ditemukan."); }
return sheet;
}

function sheetToJSON(sheet) {
var values = sheet.getDataRange().getValues();
if (values.length <= 1) return [];
var headers = values[0];
var data = [];
for (var i = 1; i < values.length; i++) {
if (values[i].join("") == "") continue;
var obj = {};
for (var j = 0; j < headers.length; j++) {
obj[headers[j]] = values[i][j];
}
data.push(obj);
}
return data;
}

function getAll(sheetName) {
try {
var sheet = getSheet(sheetName);
var result = sheetToJSON(sheet);
return jsonResponse({ status: true, total: result.length, data: result });
} catch (err) {
return jsonResponse({ status: false, message: err.toString() });
}
}

function generateProductId(sheet) {
var lastRow = sheet.getLastRow();
if (lastRow <= 1) return "P001";
var lastId = sheet.getRange(lastRow, 1).getValue();
if (!lastId) return "P001";
var number = parseInt(lastId.toString().replace("P", ""));
number++;
return "P" + number.toString().padStart(3, '0');
}

function insertRow(sheetName, data) {
try {
var sheet = getSheet(sheetName);
var headers = sheet.getRange(1, 1, 1, sheet.getLastColumn()).getValues()[0];

    if (headers[0].toLowerCase().includes("id")) {
      var idKey = headers[0];
      if (!data[idKey]) {
        data[idKey] = generateProductId(sheet);
      }
    }

    var row = [];
    for (var i = 0; i < headers.length; i++) {
      row.push(data[headers[i]] !== undefined ? data[headers[i]] : "");
    }
    sheet.appendRow(row);
    return jsonResponse({ status: true, message: "Data berhasil ditambahkan.", data: data });

} catch (err) {
return jsonResponse({ status: false, message: err.toString() });
}
}

// ==========================================
// UPDATE DATA (VERSI FLEXIBLE & MULTI-KEY)
// ==========================================
function updateRow(sheetName, data) {
try {
var sheet = getSheet(sheetName);
var values = sheet.getDataRange().getValues();
var headers = values[0];

    // Mencari kolom mana yang bertindak sebagai ID (kolom yang mengandung kata 'id')
    var idIndex = -1;
    var idKeyInSheet = "";

    for (var i = 0; i < headers.length; i++) {
      if (headers[i].toLowerCase().includes("id")) {
        idIndex = i;
        idKeyInSheet = headers[i];
        break; // Utamakan kolom ID pertama yang ditemukan
      }
    }

    if (idIndex == -1) {
      return jsonResponse({ status: false, message: "Kolom ID tidak ditemukan di Google Sheet." });
    }

    // Mencari apakah Flutter mengirimkan data ID tersebut (mengabaikan huruf besar/kecil dari Flutter)
    var targetId = "";
    for (var key in data) {
      if (key.toLowerCase() === idKeyInSheet.toLowerCase()) {
        targetId = String(data[key]).trim();
        break;
      }
    }

    if (!targetId) {
      return jsonResponse({
        status: false,
        message: "ID wajib diisi. Kirimkan data dengan kunci '" + idKeyInSheet + "' dari Flutter."
      });
    }

    // Proses mencari baris data di Sheet dan melakukan Update
    for (var i = 1; i < values.length; i++) {
      var rowId = String(values[i][idIndex]).trim();

      if (rowId == targetId) {
        for (var j = 0; j < headers.length; j++) {
          var sheetKey = headers[j];

          // Cari data dari Flutter yang cocok dengan nama kolom di Sheet
          for (var flutterKey in data) {
            if (flutterKey.toLowerCase() === sheetKey.toLowerCase() && j != idIndex) {
              values[i][j] = data[flutterKey];
            }
          }
        }

        sheet.getRange(i + 1, 1, 1, headers.length).setValues([values[i]]);
        return jsonResponse({ status: true, message: "Data pada sheet " + sheetName + " berhasil diupdate." });
      }
    }

    return jsonResponse({ status: false, message: "Data dengan ID '" + targetId + "' tidak ditemukan." });

} catch (err) {
return jsonResponse({ status: false, message: err.toString() });
}
}

// ==========================================
// DELETE DATA (VERSI FLEXIBLE & MULTI-KEY)
// ==========================================
function deleteRow(sheetName, data) {
try {
var sheet = getSheet(sheetName);
var values = sheet.getDataRange().getValues();
var headers = values[0];

    var idIndex = -1;
    var idKeyInSheet = "";

    for (var i = 0; i < headers.length; i++) {
      if (headers[i].toLowerCase().includes("id")) {
        idIndex = i;
        idKeyInSheet = headers[i];
        break;
      }
    }

    if (idIndex == -1) {
      return jsonResponse({ status: false, message: "Kolom ID tidak ditemukan di Google Sheet." });
    }

    var targetId = "";
    for (var key in data) {
      if (key.toLowerCase() === idKeyInSheet.toLowerCase()) {
        targetId = String(data[key]).trim();
        break;
      }
    }

    if (!targetId) {
      return jsonResponse({
        status: false,
        message: "ID wajib diisi. Kirimkan data dengan kunci '" + idKeyInSheet + "' dari Flutter."
      });
    }

    for (var i = 1; i < values.length; i++) {
      var rowId = String(values[i][idIndex]).trim();

      if (rowId == targetId) {
        sheet.deleteRow(i + 1);
        return jsonResponse({ status: true, message: "Data pada sheet " + sheetName + " berhasil dihapus." });
      }
    }

    return jsonResponse({ status: false, message: "Data dengan ID '" + targetId + "' tidak ditemukan." });

} catch (err) {
return jsonResponse({ status: false, message: err.toString() });
}
}

// =========================
// LOGIN ADMIN
// =========================
function loginAdmin(data) {
try {
if (!data.username || !data.password) {
return jsonResponse({ status: false, message: "Username dan Password wajib diisi." });
}
var sheet = getSheet(SHEET_ADMIN);
var admins = sheetToJSON(sheet);

    for (var i = 0; i < admins.length; i++) {
      if (String(admins[i].username) == String(data.username) && String(admins[i].password) == String(data.password)) {
        return jsonResponse({ status: true, message: "Login berhasil.", data: admins[i] });
      }
    }
    return jsonResponse({ status: false, message: "Username atau Password salah." });

} catch (err) {
return jsonResponse({ status: false, message: err.toString() });
}
}

// =========================
// TEST API
// =========================
function testAPI() {
return jsonResponse({ status: true, message: "API Google Apps Script berjalan dengan baik." });
}
