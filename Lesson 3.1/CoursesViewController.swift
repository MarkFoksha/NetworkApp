//
//  CoursesViewController.swift
//  Lesson 3.1
//
//  Created by Марк Фокша on 05.02.2023.
//

import UIKit

class CoursesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var courses = [Course]()
    private var courseUrl: String?
    private var courseName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchData()
        // Do any additional setup after loading the view.
    }
    
    func fetchData() {
        let urlString = "https://swiftbook.ru/wp-content/uploads/api/api_courses"
        
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession.shared
        
        session.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                self.courses = try decoder.decode([Course].self, from: data)
                DispatchQueue.main.sync {
                    self.tableView.reloadData()
                }
            } catch let error {
                print(String(describing: error))
            }
        }.resume()
    }
    
    func configure(cell: TableViewCell, indexPath: IndexPath) {
        let course = courses[indexPath.row]
        cell.nameOfCourse.text = course.name
        cell.numberOfLessons.text = "Number of lessons: \(course.numberOfLessons)"
        cell.numberOfTests.text = "Number of tests: \(course.numberOfTests)"
        
        DispatchQueue.global().async {
            guard let imageUrl = URL(string: course.imageUrl) else { return }
            guard let data = try? Data(contentsOf: imageUrl) else { return }
            
            DispatchQueue.main.async {
                cell.courseImage.image = UIImage(data: data)
            }
        }
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let webViewController = segue.destination as! WebViewController
        webViewController.selectedCourses = courseName
        
        if let courseUrl = courseUrl {
            webViewController.courseUrl = courseUrl
        }
    }
    
}



//MARK: - UITableViewDataSource
extension CoursesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        configure(cell: cell, indexPath: indexPath)
        
        return cell
    }
    
    
}

//MARK: - UITableViewDelegate
extension CoursesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let course = courses[indexPath.row]
        courseUrl = course.link
        courseName = course.name
        
        performSegue(withIdentifier: "description", sender: self)
    }
}
