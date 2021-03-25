/**
 * StackOverflow "Simulator" | OOP Project
 * @author Luke Zhang
 */

/**
 * Base class for an post including answers and questions
 * Classes that inherit this are Answer (answer.pde) and Question (question.pde)
 * Even though this abstract class has no abstract methods, it is only meant to be used as a
 * template
 */
abstract class Post extends Item {
    public
    int downvotes = 0;

    public
    ArrayList<Comment> comments = new ArrayList<Comment>();

    public
    final int id;

    public
    Post(User user, int id, String content, long timestamp) {
        super(user, content, timestamp);

        this.id = id;
    }

    public
    Post(User user, int id, String content) {
        super(user, content);

        this.id = id;
    }

    public
    int getScore() {
        return this.upvotes - this.downvotes;
    }

    public
    Comment addComment(Comment comment) {
        this.comments.add(comment);

        return comment;
    }

    public
    void downvote() {
        this.downvotes++;
    }
}
