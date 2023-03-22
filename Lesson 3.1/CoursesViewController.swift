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
    private let coursesUrlString = "https://swiftbook.ru/wp-content/uploads/api/api_courses"
    private let postRequestUrl = "https://jsonplaceholder.typicode.com/posts"
    private let putRequestUrl = "https://jsonplaceholder.typicode.com/posts/1"
    

    
    func fetchData() {
        NetworkManager.fetchData(withURL: coursesUrlString) { courses in
            self.courses = courses
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func fetchDataWithAlamofire() {
        AlamofireNetworkRequest.sendRequest(withURL: coursesUrlString) { courses in
            self.courses = courses
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func postRequest() {
        AlamofireNetworkRequest.postRequest(withURL: postRequestUrl) { courses in
            self.courses = courses
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func putRequest() {
        AlamofireNetworkRequest.putRequest(withURL: putRequestUrl) { courses in
            self.courses = courses
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func configure(cell: TableViewCell, indexPath: IndexPath) {
        let course = courses[indexPath.row]
        cell.nameOfCourse.text = course.name
        cell.numberOfLessons.text = "Number of lessons: \(course.numberOfLessons ?? 0)"
        cell.numberOfTests.text = "Number of tests: \(course.numberOfTests ?? 0)"
        
        DispatchQueue.global().async {
            guard let stringURL = course.imageUrl else { return }
            
            guard let imageUrl = URL(string: stringURL) else { return }
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
