//
//  DetailViewController.swift
//  periodicTable2
//
//  Created by Graham Matthews on 9/23/19.
//  Copyright © 2019 Graham Matthews. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var header: UINavigationItem!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var appearanceLabel: UILabel!
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var phaseLabel: UILabel!
    @IBOutlet weak var discoveredByLabel: UILabel!
    @IBOutlet weak var namedByLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var atomicMassLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var densityLabel: UILabel!
    @IBOutlet weak var boilLabel: UILabel!
    @IBOutlet weak var meltLabel: UILabel!
    @IBOutlet weak var molarHeatLabel: UILabel!
    @IBOutlet weak var electronConfigLabel: UILabel!
    @IBOutlet weak var electronAffinityLabel: UILabel!
    @IBOutlet weak var electroPaulingLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let label = header { label.title = detail.name }
            if let label = symbolLabel { label.text = detail.symbol }
            if let label = categoryLabel { label.text = detail.category }
            if let label = appearanceLabel { label.text = detail.appearance }
            if let label = numLabel { label.text = String(detail.number!) }
            if let label = phaseLabel { label.text = detail.phase }
            if let label = discoveredByLabel {
                if (detail.discovered_by == nil) { label.text = "Unknown" }
                else { label.text = detail.discovered_by }
            }
            if let label = namedByLabel {
                if (detail.named_by == nil) { label.text = "Unknown" }
                else { label.text = detail.named_by }
            }
            if let label = periodLabel { label.text = String(detail.period!)}
            if let label = atomicMassLabel {
                if (detail.atomic_mass == nil) { label.text = "Unknown" }
                else { label.text = String(detail.atomic_mass!) }
            }
            if let label = colorLabel {
                if (detail.color == nil) { label.text = "None" }
                else { label.text = detail.color }
            }
            if let label = densityLabel {
                if (detail.density == nil) { label.text = "Unknown" }
                else { label.text = String(detail.density!) }
            }
            if let label = boilLabel {
                if (detail.boil == nil) { label.text = "Unknown" }
                else { label.text = String(detail.boil!) }
            }
            if let label = meltLabel {
                if (detail.melt == nil) { label.text = "Unknown" }
                else { label.text = String(detail.melt!) }
            }
            if let label = molarHeatLabel {
                if (detail.molar_heat == nil) { label.text = "Unknown" }
                else { label.text = String(detail.molar_heat!) }
            }
            if let label = electronConfigLabel {
                label.text = detail.electron_configuration
            }
            if let label = electronAffinityLabel {
                if (detail.electron_affinity == nil) { label.text = "Unknown" }
                else { label.text = String(detail.electron_affinity!) }
            }
            if let label = electroPaulingLabel {
                if (detail.electronegativity_pauling == nil) { label.text = "Unknown" }
                else { label.text = String(detail.electronegativity_pauling!)}
            }
            if let label = summaryLabel {
                label.text = detail.summary
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
    }

    var detailItem: Element? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

