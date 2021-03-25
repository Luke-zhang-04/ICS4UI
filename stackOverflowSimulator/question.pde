/**
 * StackOverflow "Simulator" | OOP Project
 * @author Luke Zhang
 */

private
int _questionId = 0;

/**
 * Class for a question
 * Inheritance goes as follows: Question extends Post extends Item
 */
class Question extends Post {
    /**
     * If post was flagged, the reason will be a string. If it wasn't, it will be null
     * A post can be flagged for duplicate, spam, needs improvement, or whatever else
     */
    public
    String flag = null;

    public
    final ArrayList<Tag> tags = new ArrayList<Tag>();

    public
    Answer bestAnswer = null;

    public
    final ArrayList<Answer> answers = new ArrayList<Answer>();

    public
    final String title;

    public
    Question(User user, String title, String content, long timestamp, String[] tags) {
        super(user, _questionId, content, timestamp);

        user.questions.add(this);
        this.title = title;
        _questionId++;
        this._setTags(tags);
    }

    public
    Question(User user, String title, String content, String[] tags) {
        super(user, _questionId, content);

        user.questions.add(this);
        this.title = title;
        _questionId++;
        this._setTags(tags);
    }

    public
    Question(User user, String title, String content, long timestamp) {
        this(user, title, content, timestamp, new String[0]);
    }

    public
    Question(User user, String title, String content) {
        this(user, title, content, new String[0]);
    }

    public
    Answer answer(Answer answer) {
        this.answers.add(answer);

        return answer;
    }

    @Override public String toString() {
        return String.format("%d - %s\n    %s", this.getScore(), this.title, this.content);
    }

    /** Sets the tags for the question and globally */
    private
    void _setTags(String[] tags) {
        for (String tag : tags) {
            if (tag != null) {
                boolean isExistingTag = allTags.containsKey(tag);
                Tag targetTag = isExistingTag ? allTags.get(tag) : new Tag(tag);

                if (!isExistingTag) {            // If the tag doesn't exist
                    allTags.put(tag, targetTag); // Create a new tag
                }

                targetTag.questions.add(this); // Add this question to that tag
                this.tags.add(targetTag);      // Add this tag to this question
            }
        }
    }
}
