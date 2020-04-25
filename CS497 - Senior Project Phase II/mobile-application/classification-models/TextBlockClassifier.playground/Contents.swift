import Foundation
import CreateML
import NaturalLanguage

let fileurl = URL(fileURLWithPath: "/Users/gmatthews/Documents/TextBlockClassifier.playground/Resources/text.json")

let data = try MLDataTable(contentsOf: fileurl)

let classifier = try MLTextClassifier(trainingData: data, textColumn: "text", labelColumn: "category")
let classifierEval = classifier.evaluation(on: data, textColumn: "text", labelColumn: "category")

let metadata = MLModelMetadata(author: "Graham Matthews", shortDescription: "Classifies text blocks for Outreach Tracking Tool automated entry", license: nil, version: "1.0", additional: nil)

try classifier.write(toFile: "/Users/gmatthews/Documents/outreachTrackingTool/outreachTrackingTool/TextBlockClassifier.mlmodel", metadata: metadata)
