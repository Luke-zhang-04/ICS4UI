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
        user.comments.add(this);
    }

    public
    Comment(User user, Post post, String content) {
        super(user, content);

        this.post = post;
        user.comments.add(this);
    }

    public
    int getScore() {
        return this.upvotes;
    }

    @Override public String toString() {
        return String.format("%d - by %s - %s", this.getScore(), this.user.name, this.content);
    }
}
