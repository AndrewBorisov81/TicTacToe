import UIKit

class ViewController: UIViewController {

    // Game variables
    var currentPlayer = "X"
    var board = [["", "", ""], ["", "", ""], ["", "", ""]]
    var buttons: [[UIButton]] = []

    // Label to show next player
    var nextPlayerLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNextPlayerLabel()
        setupBoard()
        updateNextPlayerLabel()
    }

    func setupBoard() {
        let buttonSize: CGFloat = view.frame.width / 3

        for row in 0..<3 {
            var buttonRow: [UIButton] = []

            for col in 0..<3 {
                let button = UIButton()
                button.translatesAutoresizingMaskIntoConstraints = false
                button.setTitle("", for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                button.backgroundColor = .systemGray4
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor.black.cgColor
                button.tag = row * 3 + col
                button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)

                view.addSubview(button)
                buttonRow.append(button)

                // Add constraints
                NSLayoutConstraint.activate([
                    button.widthAnchor.constraint(equalToConstant: buttonSize),
                    button.heightAnchor.constraint(equalToConstant: buttonSize),
                    button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CGFloat(col) * buttonSize),
                    button.topAnchor.constraint(equalTo: nextPlayerLabel.bottomAnchor, constant: CGFloat(row) * buttonSize + 20)
                ])
            }

            buttons.append(buttonRow)
        }
    }

    func setupNextPlayerLabel() {
        nextPlayerLabel = UILabel()
        nextPlayerLabel.translatesAutoresizingMaskIntoConstraints = false
        nextPlayerLabel.textAlignment = .center
        nextPlayerLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        nextPlayerLabel.textColor = .black
        view.addSubview(nextPlayerLabel)

        // Add constraints
        NSLayoutConstraint.activate([
            nextPlayerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nextPlayerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nextPlayerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nextPlayerLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    func updateNextPlayerLabel() {
        nextPlayerLabel.text = "Next Player: \(currentPlayer)"
    }

    @objc func buttonTapped(_ sender: UIButton) {
        let row = sender.tag / 3
        let col = sender.tag % 3

        // Ignore if already tapped
        if board[row][col] != "" {
            return
        }

        // Update board and button title
        board[row][col] = currentPlayer
        sender.setTitle(currentPlayer, for: .normal)

        // Check for a winner or draw
        if checkWinner() {
            showAlert(title: "Player \(currentPlayer) Wins!", message: "Congratulations!")
            resetBoard()
        } else if checkDraw() {
            showAlert(title: "Draw!", message: "Try again.")
            resetBoard()
        } else {
            // Switch player
            currentPlayer = currentPlayer == "X" ? "O" : "X"
            updateNextPlayerLabel()
        }
    }

    func checkWinner() -> Bool {
        // Check rows, columns, and diagonals
        for i in 0..<3 {
            if board[i][0] == currentPlayer && board[i][1] == currentPlayer && board[i][2] == currentPlayer {
                return true
            }
            if board[0][i] == currentPlayer && board[1][i] == currentPlayer && board[2][i] == currentPlayer {
                return true
            }
        }

        if board[0][0] == currentPlayer && board[1][1] == currentPlayer && board[2][2] == currentPlayer {
            return true
        }

        if board[0][2] == currentPlayer && board[1][1] == currentPlayer && board[2][0] == currentPlayer {
            return true
        }

        return false
    }

    func checkDraw() -> Bool {
        for row in board {
            if row.contains("") {
                return false
            }
        }
        return true
    }

    func resetBoard() {
        board = [["", "", ""], ["", "", ""], ["", "", ""]]
        currentPlayer = "X"

        for row in buttons {
            for button in row {
                button.setTitle("", for: .normal)
            }
        }

        updateNextPlayerLabel()
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
