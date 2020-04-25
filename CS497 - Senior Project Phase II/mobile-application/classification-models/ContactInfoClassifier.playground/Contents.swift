import Foundation
import CreateML
import NaturalLanguage

let fileurl = URL(fileURLWithPath: "/Users/gmatthews/Documents/ContactInfoClassifier.playground/Resources/text.json")

let data = try MLDataTable(contentsOf: fileurl)

let classifier = try MLTextClassifier(trainingData: data, textColumn: "text", labelColumn: "category")
let classifierEval = classifier.evaluation(on: data, textColumn: "text", labelColumn: "category")

print("Classification confusion: ")
print(classifierEval.confusion)
print("Classification precisionRecall: ")
print(classifierEval.precisionRecall)

let strings = [
    "123 Candy Cane Ln",
    "5816 Twickingham CT, Evansville, IN",
    "gamedaystudios.com",
    "agar.io",
    "discord.com",
    "resume.com/kp67",
    "Marcy Matthews",
    "Graham Matthews",
    "Jeremy Matthews",
    "John Cameron"
]

for string in strings {
    let prediction = try classifier.prediction(from: string)
    print("String " + string + " is a(n) " + String(prediction))
}

let metadata = MLModelMetadata(author: "Graham Matthews", shortDescription: "Classifies contact information text blocks for Outreach Tracking Tool automated entry", license: nil, version: "1.0", additional: nil)

try classifier.write(toFile: "/Users/gmatthews/Documents/outreachTrackingTool/outreachTrackingTool/ContactInfoClassifier.mlmodel", metadata: metadata)
