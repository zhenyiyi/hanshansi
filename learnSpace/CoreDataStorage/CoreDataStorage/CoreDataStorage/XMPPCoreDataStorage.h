#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

/**
 * This class provides an optional base class that may be used to implement
 * a CoreDataStorage class for an xmpp extension (or perhaps any core data storage class).
 * 
 * 它作用于自己的调度队列使它很容易提供存储多个扩展实例
 * It operates on its own dispatch queue which allows it to easily provide storage for multiple extension instance.
 * 更重要的是,它巧妙缓冲区保存业务最大化性能!
 * More importantly, it smartly buffers its save operations to maximize performance!
 * 
 * 它使用两种技术。
 * It does this using two techniques:
 * 
 * 1.-----------------------------------------------------
 * 1.首先,它监视等待的请求的数量。
 * First, it monitors the number of pending requests.
 * 当一个类的操作请求,它增加一个原子变量,和管理这个请求。
 * When a operation is requested of the class, it increments an atomic variable, and schedules the request.
 * 请求被处理之后,它减少原子变量
 * After the request has been processed, it decrements the atomic variable.
 * 在这一点上，如果有其他等待的请求,它使用的信息来决定是否现在保存,或推迟保存操作,直到等待的请求已经被执行
 * At this point it knows if there are other pending requests,
 * and it uses the information to decide if it should save now,
 * or postpone the save operation until the pending requests have been executed.
 * 
 * 2.--------------------------------------------------
 * 2.第二，它监视未保存的数量。
 * Second, it monitors the number of unsaved changes.
 * 从 托管对象上下文保留任何改变对象,直到他们保存到磁盘，这是一个重要的内存管理关注改变对象的数量保持在健康的范围。
 * Since NSManagedObjectContext retains any changed objects until they are saved to disk
 * it is an important memory management concern to keep the number of changed objects within a healthy range.
 * 这类使用一个可配置的saveThreshold保存在适当的时间
 * This class uses a configurable saveThreshold to save at appropriate times.
 * 
 * 这个类也提供了一些有用的特性,比如防止多个实例使用相同的数据库文件(冲突)xmppStream的缓存,。myJID来提高性能
 * This class also offers several useful features such as
 * preventing multiple instances from using the same database file (conflict)
 * and caching of xmppStream.myJID to improve performance.
 * 
 * For more information on how to extend this class,
 * please see the XMPPCoreDataStorageProtected.h header file.
 * 
 * The framework comes with several classes that extend this base class such as:
 * - XMPPRosterCoreDataStorage       (Extensions/Roster)
 * - XMPPCapabilitiesCoreDataStorage (Extensions/XEP-0115)
 * - XMPPvCardCoreDataStorage        (Extensions/XEP-0054)
 * 
 * Feel free to skim over these as reference implementations.
**/

@interface XMPPCoreDataStorage : NSObject {
@private
	
	NSMutableDictionary *myJidCache;///<jid 缓存Map
	
	int32_t pendingRequests; ///< 等待请求的数量
	
	NSManagedObjectModel *managedObjectModel; ///< 托管对象
	NSPersistentStoreCoordinator *persistentStoreCoordinator; ///< 存储协调器
	NSManagedObjectContext *managedObjectContext;             ///< 托管对象上下文。
	NSManagedObjectContext *mainThreadManagedObjectContext;   ///< 主线程托管对象上下文。
    
    NSMutableArray *willSaveManagedObjectContextBlocks; ///< 将要保存托管对象上下文block
    NSMutableArray *didSaveManagedObjectContextBlocks;  ///< 已经保存托管对象上下文block
	
@protected
	
	NSString *databaseFileName;  ///< 数据库文件名字
    NSDictionary *storeOptions;  ///< 存储策略。
	NSUInteger saveThreshold;    ///< 保存临界值
	NSUInteger saveCount;        ///< 保存数量
    
    BOOL autoRemovePreviousDatabaseFile; ///< 自动移除以前的数据库文件
    BOOL autoRecreateDatabaseFile;        ///< 自动创建数据库文件
    BOOL autoAllowExternalBinaryDataStorage; ///< 自动允许额外的二进制数据存储
	
	dispatch_queue_t storageQueue; ///< 存储队列
	void *storageQueueTag;        ///< 存储队列tag。
}

/**
 * 根据数据库存储名称在SQLite的支持下，初始化一个 core data存储实力
 * Initializes a core data storage instance, backed by SQLite, with the given database store filename.
 * 建议数据库filname使用文件扩展名(如“sqlite”。“XMPPRoster.sqlite”)。
 * It is recommended your database filname use the "sqlite" file extension (e.g. "XMPPRoster.sqlite").
 * 如果你使用nil,文件名会自动使用默认数据库。
 * If you pass nil, a default database filename is automatically used.
 * 这个默认来源于类名，意味着子类将默认数据库文件名来自该子类名称。
 * This default is derived from the classname,
 * meaning subclasses will get a default database filename derived from the subclass classname.
 *
 * 如果您尝试创建该类的实例相同的databaseFileName作为另一个现有的实例,这个方法将返回nil
 * If you attempt to create an instance of this class with the same databaseFileName as another existing instance,
 * this method will return nil.
 **/
- (id)initWithDatabaseFilename:(NSString *)databaseFileName storeOptions:(NSDictionary *)storeOptions;

/**
 * 支持 内存存储。
 * Initializes a core data storage instance, backed by an in-memory store.
**/
- (id)initWithInMemoryStore;

/**
 * 数据库名称，没有调用初始化方法返回nil。
 * Readonly access to the databaseFileName used during initialization.
 * If nil was passed to the init method, returns the actual databaseFileName being used (the default filename).
**/
@property (readonly) NSString *databaseFileName;

/**
 * 访问数据库策略
 * Readonly access to the databaseOptions used during initialization.
 * If nil was passed to the init method, returns the actual databaseOptions being used (the default databaseOptions).
 **/
@property (readonly) NSDictionary *storeOptions;

/**
 * 阈值指定的最大数量未保存的更改保存到nsmanagedobject保存之前触发。
 * 自NSManagedObjectContext保留任何改变对象,直到他们保存到磁盘
 * 这是一个重要的内存管理关注改变对象的数量保持在健康的范围
 * The saveThreshold specifies the maximum number of unsaved changes to NSManagedObjects before a save is triggered.
 * 
 * Since NSManagedObjectContext retains any changed objects until they are saved to disk
 * it is an important memory management concern to keep the number of changed objects within a healthy range.
 *
 * Default 500
**/
@property (readwrite) NSUInteger saveThreshold;

/**
 * 提供了访问的线程安全组件CoreData堆栈
 * Provides access to the the thread-safe components of the CoreData stack.
 * 
 * 请注意:
 * Please note:
 * ‘managedObjectContext’ 对于存储队列是私有的
 * The managedObjectContext is private to the storageQueue.
 * 如果你在主线程可以使用mainThreadManagedObjectContext。*否则你必须创建和使用自己的managedObjectContext。
 * If you're on the main thread you can use the mainThreadManagedObjectContext.
 * Otherwise you must create and use your own managedObjectContext.
 *  
 * 如果你认为你可以简单地添加一个属性为私营,获取*然后你需要去阅读核心数据的文档,*专门一节题为“core data并发“
 * If you think you can simply add a property for the private managedObjectContext,
 * then you need to go read the documentation for core data,
 * specifically the section entitled "Concurrency with Core Data".
 * 
 * @see mainThreadManagedObjectContext
**/
@property (strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

/**
 * 便利的方法去获取适合使用在主线程。这里只用于从主线程。
 * Convenience method to get a managedObjectContext appropriate for use on the main thread.
 * This context should only be used from the main thread.
 * 
 * NSManagedObjectContext CoreData堆栈是一个轻量级的线程不安全的组成部分
 * NSManagedObjectContext is a light-weight thread-UNsafe component of the CoreData stack.
 * 因此获取只能从一个线程访问,或从一个序列化的队列。
 * Thus a managedObjectContext should only be accessed from a single thread, or from a serialized queue.
 * 
 * ‘managedObjectContext’ 与存储协调器相关联。
 * A managedObjectContext is associated with a persistent store.
 * 在大多数情况下,持久化存储是一个sqlite数据库文件
 * In most cases the persistent store is an sqlite database file.
 * 所以想获取作为底层数据库表的缓存。
 * So think of a managedObjectContext as a thread-specific cache for the underlying database.
 * 
 * 这个方法是懒加载创建一个合适的托
 * This method lazily creates a proper managedObjectContext,
 * associated with the persistent store of this instance,
 * and configured to automatically merge changesets from other threads.
**/
@property (strong, readonly) NSManagedObjectContext *mainThreadManagedObjectContext;

/**
 * The Previous Database File is removed before creating a persistant store.
 *
 * Default NO
**/

@property (readwrite) BOOL autoRemovePreviousDatabaseFile;

/**
 * The Database File is automatically recreated if the persistant store cannot read it e.g. the model changed or the file became corrupt.
 * For greater control overide didNotAddPersistentStoreWithPath:
 *
 * Default NO
**/
@property (readwrite) BOOL autoRecreateDatabaseFile;

/**
 * This method calls setAllowsExternalBinaryDataStorage:YES for all Binary Data Attributes in the Managed Object Model.
 * On OS Versions that do not support external binary data storage, this property does nothing.
 *
 * Default NO
**/
@property (readwrite) BOOL autoAllowExternalBinaryDataStorage;

@end
