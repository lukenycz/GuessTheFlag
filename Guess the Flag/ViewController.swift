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
    //var scoreInit.score = 0
    var correctAnswer = 0
    var counter = 0
    var wrongAnswer = " "
    
    class userScore: NSObject, Codable {
        var score = 0
        init(score: Int) {
            self.score = score
        }
    }
    var scored = [userScore]()
    var scoreInit = userScore(score: 0)
    
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
    }
    override func viewWillAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard

        if let savedScore = defaults.object(forKey: "scored") as? Data {
            let jsonDecoder = JSONDecoder()

            do {
                scored = try jsonDecoder.decode([userScore].self, from: savedScore)
                print(scoreInit.score)
            } catch {
                print("Failed to load score")
            }
        }
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
            if let savedData = try? jsonEncoder.encode(scored) {
                let defaults = UserDefaults.standard
                defaults.set(savedData, forKey: "scored")
            } else {
                print("Failed to save score.")
            }
    }

    func askQuestion(action: UIAlertAction! = nil) {
        
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
    
        counter += 1
        title = "\(countries[correctAnswer].uppercased()), Score is: \(scoreInit.score)"

    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        
        if sender.tag == correctAnswer {
            title = "Correct"
            scoreInit.score += 1
           // counter += 1
        } else {
            wrongAnswer = countries[sender.tag]
            title = "Wrong, thats a flag of \(wrongAnswer)"
            scoreInit.score -= 1
           // counter += 1
        }
    
        let ac = UIAlertController(title: title, message: "Your score is \(scoreInit.score)", preferredStyle: .alert)

        if counter <= 10 {
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            present(ac, animated: true)
            save()
            
        }else {
        let at = UIAlertController(title: "10 guesses done", message: "You have reached the end of this game, your final Score is \(scoreInit.score)", preferredStyle: .alert)
                   at.addAction(UIAlertAction(title: "Restart", style: .default, handler: askQuestion))
                    present(at, animated: true)
            counter = 0
            scoreInit.score = 0
        }
        save()
        reloadInputViews()
        print("scoreinit\(scoreInit.score)")
    }

    @objc func showScore() {
        let showScore = UIAlertController(title: nil, message: "Your score is \(scoreInit.score)", preferredStyle: .alert)
        showScore.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
        showScore.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(showScore, animated: true)
    }
}

