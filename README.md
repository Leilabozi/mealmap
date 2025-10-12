# Original App Design Project 

## MealMap

### Overview

Description
***MealMap*** is an iOS app designed to streamline weekly meal planning and grocery shopping. Whether you're a busy student, fitness enthusiast, or someone looking to eat more intentionally, MealMap helps you organize meals, explore recipes, and build efficient shopping lists — all in one sleek, user-friendly experience.

App Evaluation

*Category*: Health & Fitness / Productivity

*Mobile*: This app is a native iOS application built in Swift, using UIKit, optimized for iPhone screens.

*Story*: MealMap helps users plan meals for the week, explore new recipes, and generate grocery lists — all in one organized flow. The app supports busy individuals looking to improve eating habits and simplify food prep.

*Market*: MealMap targets health-conscious users, students, and working professionals who want to eat better and save time.

*Habit*: MealMap encourages weekly usage (e.g., every Sunday night), with optional daily interaction to view meals or check off grocery items. Over time, users build a personal routine of planning and cooking efficiently.

*Scope*:The MVP will focus on three core flows - creating a meal plan, browsing and saving recipes, generating grocery list.

### Video Walkthrough 
<div>
    <a href="https://www.loom.com/share/7dcd07c1fd044ef683d920089303251c">
    </a>
    <a href="https://www.loom.com/share/7dcd07c1fd044ef683d920089303251c">
      <img style="max-width:300px;" src="https://cdn.loom.com/sessions/thumbnails/7dcd07c1fd044ef683d920089303251c-c64402c87571a9f4-full-play.gif">
    </a>
  </div>

### Product Spec
**1. User Stories (Required and Optional)**
Required Must-have Stories
[x] User can create and view a weekly meal plan
[x] User can browse a list of recipes
[x] User can view recipe details (ingredients, steps, image)
[x] User can add a recipe to a specific day
[x] User can view grocery list auto-generated from meals
[x] User can delete item from the weekly planner 


Future Nice-to-have Stories

- User can filter recipes by diet type or ingredients
- User can favorite/save recipes
- User can mark grocery items as purchased


**2. Screen Archetypes**
🗓 Meal Plan Screen - view weekly calendar and add meals to specific days
Stories: View weekly plan, add meals to days
🍲 Recipe List Screen - browse/search recipes
Stories: View recipe list, filter/search
📖 Recipe Detail Screen - show title, ingredients, steps, image
Stories: View details, add to plan
🛒 Grocery List Screen - view ingredients grouped by category, check off items
Stories: View list, mark as complete

**3. Navigation**
Tab Navigation (Tab to Screen)
Meal Plan → Weekly meal calendar
Recipes → Recipe library
Grocery List → Auto-generated shopping list
Flow Navigation (Screen to Screen)
Meal Plan → Recipe Detail (select a recipe to add)
Recipes → Recipe Detail
Recipe Detail → Meal Plan (assign to a day)
Recipe Detail → Grocery List (view ingredients)

### **Wireframes**
https://www.figma.com/design/fOras4tMErBhFtrB2r3y1l/MealMap?node-id=0-1&t=LNt6whteQ9RWdOpr-1

### **Schema**
[This section will be completed in Unit 9]

### **Models**
| **Model**     | **Properties**                                                   |
| ------------- | ---------------------------------------------------------------- |
| `Recipe`      | id, title, imageURL, ingredients\[], steps\[], cookTime, tags\[] |
| `MealPlan`    | id, dayOfWeek, recipeIDs\[]                                      |
| `GroceryItem` | id, name, quantity, isChecked, associatedRecipeID                |


### **Networking**
Recipe List Screen
GET https://www.themealdb.com/api.php
