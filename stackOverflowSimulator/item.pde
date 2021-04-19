/**
 * StackOverflow "Simulator" | OOP Project
 * @author Luke Zhang
 */

/**
 * Base class for an item including a comment, question, or answer
 * Classes that inherit this are Comment (comment.pde) and Post (post.pde)
 */
abstract class Item {
    /** Item upvotes, and upvotes only b/c comments don't have downvotes */
    public
    int upvotes = 0;

    public
    final User user;

    /** Unix time stamp, which is apparently a long int */
    public
    final long timestamp;

    public
    String content;

    public
    Item(User user, String content, long timestamp) {
        this.user = user;
        this.content = content;
        this.timestamp = timestamp;
    }

    public
    Item(User user, String content) {
        this(user, content, System.currentTimeMillis());
    }

    public
    void upvote() {
        this.upvotes++;
        this.user.reputation += 1;
    }

    abstract int getScore();
}
