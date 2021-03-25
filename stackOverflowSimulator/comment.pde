/**
 * StackOverflow "Simulator" | OOP Project
 * @author Luke Zhang
 */

/** Class representing a comment */
class Comment extends Item {
    public
    final Post post;

    /** Why is this necessary? */
    public
    Comment(User user, Post post, String content, long timestamp) {
        super(user, content, timestamp);

        this.post = post;
    }

    public
    Comment(User user, Post post, String content) {
        super(user, content);

        this.post = post;
    }

    public
    int getScore() {
        return this.upvotes;
    }
}
