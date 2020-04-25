import Foundation
import CreateML
import NaturalLanguage

let fileurl = URL(fileURLWithPath: "/Users/gmatthews/Documents/EduInfoClassifier.playground/Resources/text.json")

let data = try MLDataTable(contentsOf: fileurl)

let classifier = try MLTextClassifier(trainingData: data, textColumn: "text", labelColumn: "category")
let classifierEval = classifier.evaluation(on: data, textColumn: "text", labelColumn: "category")

print("Classification confusion: ")
print(classifierEval.confusion)
print("Classification precisionRecall: ")
print(classifierEval.precisionRecall)

let strings = [
    "Computer Science",
    "B.S. Computer Science",
    "University of Evansville",
    "Abraham Lincoln University",
    "GPA: 3.2",
    "Dean's List - Fall 2017",
    "President of Purple Reign",
    "Organized weekly meetings where members gave input on how to better the organization",
    "Pitched marketing ideas to reach clients"
]

for string in strings {
    let prediction = try classifier.prediction(from: string)
    print("String " + string + " is a(n) " + String(prediction))
}

let metadata = MLModelMetadata(author: "Graham Matthews", shortDescription: "Classifies education information text blocks for Outreach Tracking Tool automated entry", license: nil, version: "1.0", additional: nil)

try classifier.write(toFile: "/Users/gmatthews/Documents/outreachTrackingTool/outreachTrackingTool/EduInfoClassifier.mlmodel", metadata: metadata)
