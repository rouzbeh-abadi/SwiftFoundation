
import Foundation

public class TaskOperation: Operation {
    
    private let task: URLSessionDataTask
    
    public init(task: URLSessionDataTask) {
        self.task = task
    }
    
    public override func start() {
        super.start()
        task.resume()
    }
    
    public override func main() {
        super.main()
        if isCancelled {
            task.cancel()
        }
    }
    
    public override func cancel() {
        super.cancel()
        task.cancel()
    }
}
