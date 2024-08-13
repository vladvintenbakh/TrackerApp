# **Tracker**

https://github.com/user-attachments/assets/5002cd1e-9bb2-4d2f-a905-24cc623d6497

# Links

[Figma Design](https://www.figma.com/file/gONgrq8Q5PfEs1LUo7KX4h/Tracker?type=design&node-id=0-1&mode=design)

# Purpose

The Tracker app allows its users to create and track habits of their choosing.

Main usage:
- Tracking habits by day of the week.
- Tracking individual habit progress.

# Brief app description

- The user can create a tracker card for each habit. They can specify the name, category, emoji, and card color for each habit. Schedule can also be specified for habits that repeat on certain days of the week.
- The tracker cards are grouped by category. The user can search or filter specific trackers.
- The user can view trackers for a specific date by using the date picker.
- The statistics tab shows how many trackers have been marked as completed so far.

# Functional requirements

## Onboarding

The onboarding screen is shown when the app is opened for the first time.

**The onboarding screen contains:**

1. Background image
2. Info label
3. Page control
4. Button to proceed

**Logic and available actions:**

1. The user can switch between the onboarding pages by swiping left and right. The page control changes its state upon switching to a different page.
2. The user is directed to the app's main screen when they press the "Let me try!" button. 

## Creating a tracker card

In the main screen, the user can create a tracker card for a habit or one-off event. A habit is an event that repeats on certain days of the week. One-off events are not tied to specific days of the week.

**The habit creation screen contains:**

1. Title
2. Text field for entering the tracker name
3. Category selection section
4. Schedule selection section
5. Emoji collection
6. Tracker color collection
7. "Cancel" button
8. "Create" button

The one-off event creation screen contains the same elements except the schedule selection section.

**Logic and available actions:**

1. The user can create a tracker for a habit or one-off (irregular) event. The tracker creation logic is identical for both except that irregular events do not have a schedule.
2. The user can input the tracker name in a text field.
3. The user is directed to the category selection screen upon tapping the "Category" section cell.
    1. A placeholder is displayed if the user has not created any categories.
    2. The selected category is marked with a blue check mark.
    3. The user can add a new category by pressing the "Add a new category" button.
        1. A screen will be shown with a text field where the category name can be entered and an inactive "Done" button.
        2. The "Done" button becomes active if at least one character is entered.
        3. The user can dismiss the new category creation screen by pressing the "Done" button. The newly created category is then shown in the category list. The new category is not automatically selected.
    4. When a category is selected, it is marked with a blue check mark, and the user returns to the tracker creation screen. The selected category is displayed in the tracker creation screen as a subtitle in the "Category" cell.
4. There is a "Schedule" section in the habit creation screen. Upon tapping it, a screen is shown where the user can select which days of the week the habit will repeat on. Switches can be used to pick the desired days of the week.
    1. Upon pressing the "Done" button, the user goes back to the habit creation screen. The selected days are displayed in the habit creation screen as a subtitle in the "Schedule" cell. If the user picked all days of the week, the subtitle text becomes "Every day".
5. The user can pick an emoji. The selected emoji is highlighted with light gray.
6. The user can pick a color for the tracker card. The selected color option is highlighted with light gray.
7. The user can cancel the creation of a new tracker by pressing the "Cancel" button.
8. The "Create" button is inactive until all the sections are filled. The user returns to the main screen after pressing the "Create" button. The newly created tracker is shown under the relevant category.

## Main screen

In the main screen, the user can view the created trackers for the selected date as well as edit or delete them.

**The main screen contains:**

1. The "+" button for creating a tracker
2. The "Trackers" title
3. The selected date
4. A search text field
5. Tracker cards by category. Each card contains:
    1. An emoji
    2. The tracker name
    3. The number of completed days
    4. A button for marking the tracker completed/uncompleted
6. The "Filters" button
7. Tab bar

**Logic and available actions:**

1. Tracker creation screen is opened after pressing the "+" button.
2. A calendar pops up if the date picker is tapped. If a specific date is tapped in the calendar, the trackers corresponding to that date will be displayed.
3. The user can search for trackers by name using the search bar.
    1. A placeholder is displayed if nothing is found.
4. A filter selection screen pops up upon tapping the "Filters" button.
    1. If the selected date does not have any trackers, the "Filters" button is hidden.
    2. If the "All trackers" filter is selected, all the trackers for the selected date are displayed.
    3. If the "Trackers for today" filter is selected, all the trackers for the current date are displayed.
    4. If the "Completed" filter is selected, completed trackers for the selected date are displayed.
    5. If the "Not completed" filter is selected, trackers for the selected date that have not been completed are displayed.
    6. The applied filter is marked with a blue check mark.
    7. The filter selection screen is dismissed when one of the filter options is tapped, and the corresponding trackers are shown in the main screen.
        1. A placeholder is displayed if no trackers satisfy the applied filter condition.
5. The user can scroll the tracker feed up and down.
6. If the user long presses a tracker card, the background is blurred, and the context menu for that tracker is shown.
    1. The user can tap the "Pin" button to pin a tracker card. That tracker will then be displayed under the "Pinned" category at the top.
        1. The user can tap the "Pin" button again to unpin a pinned tracker.
        2. The "Pinned" category is not shown if there are no pinned trackers.
    2. The user can tap the "Edit" button to edit a tracker. In that case, a screen that is similar to the tracker creation screen is presented.
    3. If the user taps the "Delete" button, an alert is displayed.
        1. The user can confirm the deletion of the tracker. In that case, all its data will be deleted.
        2. Alternatively, the user can cancel the deletion of the tracker and return to the main screen.
7. The user can switch between the "Trackers" and "Statistics" screens using the tab bar.

## Editing or deleting a category

In the category selection screen, the user can edit or delete existing categories.

**Logic and available actions:**

1. If the user long presses an existing category cell, the background is blurred, and the context menu for that category is shown.
    1. The user can tap the "Edit" button to edit an existing category. A screen is then shown where the user can change the name for that category. The user returns to the category list upon pressing the "Done" button.
    2. If the user taps the "Delete" button, an alert is displayed.
        1. The user can confirm the deletion of the category. In that case, all its data will be deleted.
        2. Alternatively, the user can cancel the deletion of the category.
        3. After completing or canceling the deletion, the user returns to the category list.

## Viewing the statistics

In the statistics tab, the user can view how many trackers have been marked as completed.

**The statistics screen contains:**

1. The "Statistics" title
2. A list of statistical metrics. Each metric has a title (the calculated number) and subtitle (description of the metric).
3. Tab bar

**Logic and available actions:**

1. If no data is available for any of the metrics, a placeholder is displayed.
2. If available, the user can currently view statistics for the following metrics:
    1. "Tracker(s) completed": the total number of trackers marked as completed.

## Dark mode

The app partially supports dark mode. It is enabled/disabled based on the device's system settings.

# Non-functional requirements

1. Minimum deployment version: iOS 13.4.
2. The UI elements adapt to different iPhone screens (iPhone X or higher).
3. All fonts in the app are system fonts.
4. Core Data is used for persistent storage of tracker data.
