#include <ncurses.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define SCRIPT_PATH "./theme.sh"

// --- Function Prototypes ---
void print_menu(WINDOW *menu_win, int highlight, const char *choices[], int n_choices);
void execute_command(const char *choice);

int main() {
    // --- Ncurses Initialization ---
    initscr();            // Start curses mode
    clear();
    noecho();             // Don't echo() while we do getch
    cbreak();             // Line buffering disabled
    curs_set(0);          // Hide the cursor
    
    // --- Window Setup ---
    int height, width;
    getmaxyx(stdscr, height, width); // Get screen dimensions

    // Define the themes that the script can apply
    const char *choices[] = {
        "tokyo",
        "gruvbox",
        "nord",
        "everforest",
        "blackwhite",
    };
    int n_choices = sizeof(choices) / sizeof(char *);
    int highlight = 1;
    int c;

    int menu_height = n_choices + 4; // Menu height (choices + padding + border)
    int menu_width = 30;             // A fixed width for the menu box
    int starty = (height - menu_height) / 2;
    int startx = (width - menu_width) / 2;

    WINDOW *menu_win = newwin(menu_height, menu_width, starty, startx);
    keypad(menu_win, TRUE); // Enable keyboard mapping (arrow keys)

    mvprintw(0, (width - strlen("I3 Theme Switcher")) / 2, "I3 Theme Switcher");
    mvprintw(height - 2, 2, "Use arrow keys to navigate. Press 'Enter' to select a theme or 'q' to quit.");
    refresh();

    // --- Main Input Loop ---
    print_menu(menu_win, highlight, choices, n_choices);
    while ((c = wgetch(menu_win))) {
        switch (c) {
            case KEY_UP:
            case 'k':
                if (highlight == 1)
                    highlight = n_choices;
                else
                    --highlight;
                break;
            case KEY_DOWN:
            case 'j':
                if (highlight == n_choices)
                    highlight = 1;
                else
                    ++highlight;
                break;
            case 10: // Enter key
                execute_command(choices[highlight - 1]);
                // Stay in the loop after executing.
                break;
            case 'q': // Quit
                goto end_loop; // Exit the while loop
            default:
                break;
        }
        print_menu(menu_win, highlight, choices, n_choices);
    }
end_loop:

    // --- Cleanup and Execution ---
    delwin(menu_win);
    endwin(); // End curses mode

    printf("TUI exited.\n");

    return 0;
}

/**
 * @brief Prints the menu choices to the given window.
 * @param menu_win The ncurses window to draw in.
 * @param highlight The currently selected item (1-indexed).
 * @param choices Array of string choices.
 * @param n_choices The number of choices.
 */
void print_menu(WINDOW *menu_win, int highlight, const char *choices[], int n_choices) {
    int x = 2;
    int y = 2;
    box(menu_win, 0, 0);

    // Print a title inside the box
    mvwprintw(menu_win, 0, (30 - strlen("Select a Theme")) / 2, "Select a Theme");

    for (int i = 0; i < n_choices; ++i) {
        if (highlight == i + 1) { // Highlight the present choice
            wattron(menu_win, A_REVERSE);
            mvwprintw(menu_win, y, x, "%s", choices[i]);
            wattroff(menu_win, A_REVERSE);
        } else {
            mvwprintw(menu_win, y, x, "%s", choices[i]);
        }
        ++y;
    }
    wrefresh(menu_win);
}

/**
 * @brief Executes the theme switcher script.
 * @param choice The theme name to pass to the script.
 */
void execute_command(const char *choice) {
    char command[256];
    // Construct the command string: SCRIPT_PATH "themename"
    snprintf(command, sizeof(command), "%s %s >/dev/null 2>&1", SCRIPT_PATH, choice);


    // Execute the command without printing to stdout or clearing the screen,
    // as it would interfere with the ncurses UI. The script sends a notification.
    system(command);
}


