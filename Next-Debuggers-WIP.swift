var Position_Points = {
  "None of the above": 1,
  "Lower Secondary Teacher/Tutor": 2,
  "Upper Secondary Teacher/Tutor": 3,
  "STPM Teacher/Tutor": 5
}

var Education_Points = {
  "SPM": 1,
  "STPM": 2,
  "Diploma": 3,
  "Bachelor": 5,
  "Master": 7
}
var Experience_Points = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

var Referral_Points = 3

var SPM_Tutor = 10
var STPM_Tutor = 12
var Receptionist = 4


function checkQualifications(inputNumber) {
  var spreadsheet = SpreadsheetApp.getActiveSpreadsheet()
  var ui = SpreadsheetApp.getUi()
  var sheetDuplicate = spreadsheet.getSheetByName("FormResponses")
  var values = sheetDuplicate.getRange(inputNumber, 1, 1, sheetDuplicate.getLastColumn()).getValues();

  // Validate inputNumber 
  if (inputNumber <= 0) {
    ui.alert("Invalid row number provided.")  
    return;
  }

  var lastColumn = sheetDuplicate.getLastColumn();
  if (lastColumn <= 0) {
    ui.alert("No columns found in 'FormResponses' sheet.");
    return;
  }

  var lastRow = sheetDuplicate.getLastRow();
  if (inputNumber > lastRow) {
    ui.alert("Row number exceeds the number of rows in 'FormResponses'.");
    return;
   }

  var name = values[0][1]
  var email = values[0][3]
  var yearsOfExperience = values[0][4]
  var currentPosition = values[0][6]
  var positionApplied = values[0][7]
  var referrals = values[0][12]
  var educationLevel = values[0][14]
  var languageProfiency = values[0][15]

  var points = 0; //counter for points

  var qualifiedCanditiate = true

  console.log('Name: ', name)
  console.log('Years of experience: ', yearsOfExperience)
  console.log('Curent Position: ', currentPosition)
  console.log('Position Applied : ', positionApplied)
  console.log('Referrals: ', referrals)
  console.log('Highest education level: ', educationLevel)
  console.log('Language: ', languageProfiency)
  

  //calculate the points for years of working experience
  var Experience_Value = Experience_Points[values[0][4]]
  points += Experience_Value
  console.log(Experience_Value + " points for having " + Experience_Value + " years of working experience")

  //calculate the points for current position
  var Position_Value = values[0][6]
  points += Position_Points[Position_Value]
  console.log(Position_Points[Position_Value] + " points for having position as " + Position_Value )
  
  //calculate the points for referrals
  var Referrals_Value = values[0][12]
  if(Referrals_Value === "Yes") {
    points += Referral_Points
    console.log(Referral_Points + " points for having referrals")
  }

  //calculate the points for educational level
  var Education_Value = values[0][14]
  points += Education_Points[Education_Value]
  console.log(Education_Points[Education_Value] + " points for having " + Education_Value )

  //calculate the points for language Proficiency
  var Language_Value = values[0][15]
  var partsArray = Language_Value.split(',') //parse the string 
  points += partsArray.length
  console.log(partsArray.length + " points for having " + partsArray.length + " language proficiency")

  console.log("Total points: " + points)

  //10 points for SPM Tutor, 12 points for STPM Tutor, 4 points for Receptionist
  if (positionApplied.includes("SPM")) 
  {
    qualifiedCandidate = points >= SPM_Tutor
  } 
  else if (positionApplied.includes("STPM")) 
  {
    qualifiedCandidate = points >= STPM_Tutor
  } 
  else if (positionApplied.includes("Receptionist")) 
  {
    qualifiedCandidate = points >= Receptionist
  } 
  else 
  {
    qualifiedCandidate = false
  }

  console.log(qualifiedCandidate ? "Qualified" : "Not Qualified")

  //print the output at qualified-candidate sheet
  var qualifiedSheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName("qualified-candidate")
  var lastRow = qualifiedSheet.getLastRow()
  var nextRow = lastRow + 1

  qualifiedSheet.getRange(nextRow, 1).setValue(name) // name
  qualifiedSheet.getRange(nextRow, 2).setValue(email) // email
  qualifiedSheet.getRange(nextRow, 3).setValue(positionApplied) // position applied
  qualifiedSheet.getRange(nextRow, 4).setValue(qualifiedCandidate ? "Yes" : "No") // is Qualified

  sheetDuplicate.getRange(inputNumber,20).setValue("✓")
}

function gui()
{
  var ui = SpreadsheetApp.getUi()
  var prompt = ui.prompt("Which row do you want to check on?", ui.ButtonSet.OK_CANCEL);

  if(prompt.getResponseText()) {
    var inputInNumber = Number(prompt.getResponseText());
  }

  checkQualifications(inputInNumber);
}