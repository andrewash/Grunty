# iOS Sample Project
### Guidelines
Using this sample backend, we want to produce an app that starts on a screen of posts where each cell has the title and body visible. Like a boring Twitter clone. You can use this API to pull those posts https://jsonplaceholder.typicode.com/posts

Tapping on a post should show a new screen that is like a detail screen for that post. It can include comments for that post from this route https://jsonplaceholder.typicode.com/posts/1/comments (https://jsonplaceholder.typicode.com/posts). Also include a button for more posts by the same author somewhere on the screen. Tapping that button can take you to a new screen that just lists posts in the same fashion as the first screen but only for the selected author.

These screens can be nested as much as you want. For example tap on a post, tap on more posts by that author, tap on a post, etc.

Thats it as far as guidelines. They are purposely vague because we'd like to see what you build for a simple app.

### Things We're looking for

* Code well separated into reasonable classes and functions. Plain and simple MVC is just fine but you can use any architecture pattern you want as long as you can explain it to us. Don't feel the need to over architect this, it is a simple app, but your code should be clean and maintainable.
* Good understanding of native UI elements. Feel free to customize the UI as you want, but we're looking for a good handle on native UI elements being used together.
* Semantic, well formatted Swift code. We use 100% Swift. We understand for some people Swift is more of a hobby than the language they use at work. Let us know if this is your first Swift project. It is not a problem, everyone starts somewhere. Think of this as a chance to use Swift on a simple greenfield project to learn.
* Clear, simple, and purposeful Programmatic Autolayout. We write all our UI programmatically using autolayout. Its ok if thats not your forte, give it a shot.