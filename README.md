# Viewing Party

This is a group project between [me, Travis McKinstry](https://github.com/TravisGM92), [Saryn Mooney](https://github.com/sarynm12) and [Norma Lopez](https://github.com/IamNorma).

The link to this app [can be found here.](https://gentle-brook-14232.herokuapp.com/)

To download this app onto your compter, follow the instructions labelled 'Local Setup';

### About this Project 

In this project we were expected to build an app where a user can register and create viewing parties involving a movie of their choice. The app has the following features;

Check it out

#### -a user can register and subsequently login/logout of the app<br><br>
![Register gif](https://media.giphy.com/media/3LKT2cHV2H1mXtB3I6/source.gif)
<br><br><br>
#### -a user can search through a list of 40 movies, taken from [theMovieDB API](https://developers.themoviedb.org/)<br><br>
![Top 40 Movies](https://media.giphy.com/media/e5LEivhRVFI7LMDx8b/source.gif)
<br><br><br>
#### -a user can then click on a movie, and see details such as; that movie's title, the cast, etc.<br><br>
![Movie show page](https://media.giphy.com/media/bThbLOC44JDcfP1ajK/source.gif)
<br><br>

### Learning Goals 

The purpose of this project was to get first-time practice and implemenation of API exposure and consumption as well as utilization of Continuous Integration using Travis CI. Although not required for this project, we wanted to learn how to mock external HTTP requests, which we were able to achieve with Webmock. We had a goal to implement mocking with VCR, but were unable to reach this goal within our deadline. Refactoring using Facade Design Patter was strongly encouraged for this project, which we decided as a team would be a goal for us. We achieved implementation of this design pattern and in doing so it allowed for better abstraction, encapsulation, single-responsibility. 

## Local Setup

1. Make sure you have the correct Ruby version installed (2.5.3). To check your Ruby version, from your command line, run `ruby -v`
  - If you do not have the correct version, follow the instructions to install 2.5.3: from the command line, run `rbenv install 2.5.3`
2. Make sure you have the correct Rails version installed (5.2.4.3). To check your Rails version, from your command line, run `rails -v`
  - If you do not have the correct Rails version, [follow these instructions to install 2.5.4.3](https://github.com/turingschool-examples/task_manager_rails/blob/master/rails_uninstall.md)
3. Fork and Clone the repo
4. Install gem packages: `bundle install`
5. Setup the database: `rails db:create`
6. You will need to sign up for an API key through [theMovieDB API](https://developers.themoviedb.org/)
7. From the command line, run `bundle exec figaro install`. By running this command, rails will create an application.yml file under your config folder. Open up that file, and paste your API key in by following this format: MOVIE_API_KEY: 'your api key here'
8. Once inside the project directory, run `bundle exec rspec`. You should have 800 passing tests

## Features/Wishlist
  - A new user can register with a username, email, and password. We used 'bcrypt' for password security and encryption
  - Once logged in, a user can discover the top 40 movies, as well as search for movies based on a keyword
  - On the movies index page, each movie title is a link, where a user can click to find more information about that particular movie
  - If a user navigates back to their dashboard, they can 'Add Friends'! Search for friends by typing in their email, and if that      email is associated with a registered user, then they will be added as a friend! Friendships are reciprocal, so once added by the user, that two-way friendship is created
  - If a user has added friends, they have the ability to create a viewing party! They can select which friends they would like to invite, and select a movie to show!
  - 'Recommended movies', and 'top rated movies' are both extra pieces of functionality that required additional API calls
  - Future iterations: going forward, we would love to incorporate sending an email once a user has either created a viewing party, or been invited to one. This email would serve as a notification, because currently, a user needs to sign into our app to see whether or not they have any viewing parties. This email could also include an option to a 'accept' or 'decline' an invitiation
