import Foundation
import CreateML
import NaturalLanguage

let fileurl = URL(fileURLWithPath: "/Users/gmatthews/Documents/WorkExpClassifier.playground/Resources/text.json")

let data = try MLDataTable(contentsOf: fileurl)

let classifier = try MLTextClassifier(trainingData: data, textColumn: "text", labelColumn: "category")
let classifierEval = classifier.evaluation(on: data, textColumn: "text", labelColumn: "category")

print("Classification confusion: ")
print(classifierEval.confusion)
print("Classification precisionRecall: ")
print(classifierEval.precisionRecall)

let strings = [
    "Truck Driver",
    "Police Officer",
    "Evansville Police Department",
    "University of Evansville",
    "T.J. Maxx",
    "Maintained a standard for customer support"
]

for string in strings {
    let prediction = try classifier.prediction(from: string)
    print("String " + string + " is a(n) " + String(prediction))
}

let metadata = MLModelMetadata(author: "Graham Matthews", shortDescription: "Classifies work experience text for Outreach Tracking Tool automated entry", license: nil, version: "1.0", additional: nil)

try classifier.write(toFile: "/Users/gmatthews/Documents/outreachTrackingTool/outreachTrackingTool/WorkExpClassifier.mlmodel", metadata: metadata)
