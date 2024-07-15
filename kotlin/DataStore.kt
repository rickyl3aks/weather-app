class DataStore {

    private val data: HashMap<String, Any> = HashMap()

    // ...

    fun get(key: String): Any? {
        return data[key]
    }

    fun set(key: String, value: Any) {
        data[key] = value
    }

    // ...

}