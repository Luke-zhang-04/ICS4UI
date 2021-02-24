/**
 * A List class which behaves like a Python List for Processing with almost all the same methods
 * @author Luke Zhang
 */

/**
 * Alias for append because you can reference instance methods without this in Java or something
 */
private
<T> T[] _push(T[] arr, T elem) {
    return (T[]) append(arr, elem);
}

private
<T> T[] _reverse(T[] arr) {
    return (T[]) reverse(arr);
}

private
String[] _sort(String[] arr) {
    return sort(arr);
}

private
int[] _sort(int[] arr) {
    return sort(arr);
}

/**
 * A List class which behaves like a Python List for Processing with almost all the same methods
 */
public
class List<T> {
    private
    T[] _list;

    public
    int length;

    public
    List(T[] list) {
        this._list = list;
        this.length = this._list.length;
    }

    /**
     * Appends element to the list
     */
    public
    void append(T element) {
        this._list = (T[]) _push(this._list, element);
        this.length = this._list.length;
    }

    /**
     * Clears the list
     */
    public
    void clear() {
        this._list = (T[]) new Integer[0];
        this.length = this._list.length;
    }

    /**
     * @returns a copy of the base array
     */
    public
    List<T> copy() {
        return new List<T>(this._list);
    }

    /**
     * @returns the base array
     */
    public
    T[] getArray() {
        return this._list;
    }

    /**
     * @param value to count
     * @returns number of times val appears in the array
     */
    public
    int count(T val) {
        int total = 0;

        for (T elem : this._list) {
            if (elem instanceof String && elem.equals(val)) {
                total++;
            } else if (val == elem) {
                total++;
            }
        }

        return total;
    }

    /**
     * Add the elements of array to the end of the current list
     * @param array - array of items to append
     */
    public
    void extend(T[] array) {
        this._list = (T[]) concat(this._list, array);
        this.length = this._list.length;
    }

    /**
     * Add the elements of list to the end of the current list
     * @param list - list of items to append
     */
    public
    void extend(List<T> list) {
        this._list = (T[]) concat(this._list, list.getArray());
        this.length = this._list.length;
    }

    /**
     * Gets the index of val within the list
     * @param val - value to get the index of
     * @returns the index of val; -1 if none found
     */
    public
    int index(T val) {
        for (int index = 0; index < this._list.length; index++) {
            final T elem = this._list[index];

            if (elem instanceof String && elem.equals(val)) {
                return index;
            } else if (elem == val) {
                return index;
            }
        }

        return -1;
    }

    /**
     * Inserts val into the list at position
     * @param val - value to insert
     * @param position - position to insert `val`
     */
    public
    void insert(T val, int position) {
        this._list = (T[]) splice(this._list, val, position);
        this.length = this._list.length;
    }

    /**
     * Inserts vals into the list at position
     * @param vals - values to insert
     * @param position - position to insert `vals`
     */
    public
    void insert(T[] vals, int position) {
        this._list = (T[]) splice(this._list, vals, position);
        this.length = this._list.length;
    }

    /**
     * Inserts vals into the list at position
     * @param vals - values to insert
     * @param position - position to insert `vals`
     */
    public
    void insert(List<T> vals, int position) {
        this._list = (T[]) splice(this._list, vals.getArray(), position);
        this.length = this._list.length;
    }

    /**
     * Removes item from position and returns it
     * @param position - position of element to remove
     * @returns popped item
     */
    public
    T pop(int position) {
        final T[] leftSide = (T[]) subset(this._list, 0, position);
        final T[] rightSide = (T[]) subset(this._list, position + 1);
        final T poppedValue = this._list[position];

        this._list = (T[]) concat(leftSide, rightSide);
        this.length = this._list.length;

        return poppedValue;
    }

    /**
     * Reverses the list (in place)
     */
    public
    void reverse() {
        this._list = (T[]) _reverse(this._list);
        this.length = this._list.length;
    }

    public
    void remove(T item) {
        final int index = this.index(item);

        if (index < 0) {
            return;
        }

        this.pop(index);
    }

    /**
     * Slices the array from start to end
     * @param start - start of slice
     * @returns sliced array
     */
    public
    List<T> slice(int start) {
        return new List<T>((T[]) subset(this._list, start));
    }

    /**
     * Slices the array from start to end
     * @param start - start of slice
     * @param end - end of slice not inclusive
     * @returns sliced array
     */
    public
    List<T> slice(int start, int end) {
        return new List<T>((T[]) subset(this._list, start, end - start));
    }

    /**
     * @param index - index of list item
     * @returns the element at position index
     */
    public
    T get(int index) {
        if (index < 0) {
            return this._list[this.length + index];
        }

        return this._list[index];
    }
}

// Test the list util
void setup() {
    Integer[] arr = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};

    List<Integer> myList = new List<Integer>(arr);

    println(myList.getArray());

    myList.append(10); // Add 10

    final int itemAtPosition = myList.get(2); // Get item from index 3
    final int poppedItem = myList.pop(2);     // Remove item from index 3

    println(myList.getArray());

    assert poppedItem == itemAtPosition;
    assert myList.count(10) == 2;
    assert myList.length == 10;

    Integer[] suffix = {11, 12, 13, 14};

    myList.extend(suffix);

    println(myList.getArray());

    assert myList.length == 14;
    assert myList.index(14) == myList.length - 1;

    myList.insert(3, 2);

    println(myList.getArray());

    assert myList.length == 15;
    assert myList.get(2) == 3;

    myList.remove(10);

    println(myList.getArray());

    assert myList.slice(9).length == 5;
    assert myList.slice(2, 9).get(-1) == 9;

    myList.clear();

    assert myList.length == 0;

    exit();
}
