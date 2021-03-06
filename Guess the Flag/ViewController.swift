//
//  ViewController.swift
//  Guess the Flag
//
//  Created by Łukasz Nycz on 28/06/2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var counter = 0
    var wrongAnswer = " "
    let defaults = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showScore))

        askQuestion()
        
        
        defaults.set(score, forKey: "score")
        let savedScore = defaults.data(forKey: "score")
        print(savedScore)
    }
    func askQuestion(action: UIAlertAction! = nil) {
        
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
    
        counter += 1
        title = "\(countries[correctAnswer].uppercased()), Score is: \(score)"

    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
           // counter += 1
        } else {
            wrongAnswer = countries[sender.tag]
            title = "Wrong, thats a flag of \(wrongAnswer)"
            score -= 1
           // counter += 1
        }
        
        // Animation
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: [], animations: {
            sender.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        })
        sender.transform = CGAffineTransform(scaleX: 1, y: 1)
        
    
        let ac = UIAlertController(title: title, message: "Your score is \(score)", preferredStyle: .alert)

        if counter <= 10 {
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            present(ac, animated: true)
            
        }else {
        let at = UIAlertController(title: "10 guesses done", message: "You have reached the end of this game, your final Score is \(score)", preferredStyle: .alert)
                   at.addAction(UIAlertAction(title: "Restart", style: .default, handler: askQuestion))
                    present(at, animated: true)
            counter = 0
            score = 0
        }
        
    }

    @objc func showScore() {
        let showScore = UIAlertController(title: nil, message: "Your score is \(score)", preferredStyle: .alert)
        showScore.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
        showScore.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(showScore, animated: true)
    }
}

