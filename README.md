# SnakeD

SnakeD is not "yet another snake game", it is a study project to show off D  
contract programming (CP) capabilities. The goal is too verify if D contract  
programming features can cover strong design requirements. Here, those  
requirements are generated from the aeronautical industry guideline DO-178c.  

![Screenshot](https://raw.githubusercontent.com/Fr3nchK1ss/SnakeD/master/screenshot.png)

## Action plan

1. **Identify a project already using DO-178c**. The DO-178c is a complex  
    guideline completed by other guidelines; for example the DO-332: Object  
    Oriented Technology, and supplementary documents. See the pdf uploaded in  
    *Requirements*. Instead of creating a project from scratch, I found a  
    [student project on github](https://github.com/DarkMiMolle/AdaSnake) already defining DO-178c requirements for  
     a snake game.  
	
2. **Write a snake game in D using all CP techniques available**. I write the  
    game without any design planning and without reading the requirements  
    beforehand. This is important to understand: the hypothesis is that "simply
    following good CP practices" will be sufficient to cover most requirements
    whithout a lengthy design phase. A sort of blind test.
	
3. **Asking the D community for a code review**. Again, nobody is reading the  
    requirements at this point. The reviewers give their input about typical
    D style, coding standard and CP implementation.
	
4. **Compare the requirements to CP coverage**. Which requirement was covered  
    automatically by CP, and which requirement was left unchecked? This is the  
    interesting part of the project!  
	
5. **Fix the missing requirements**. Note how easy / complicated it is to make  
    the game compliant to the original requirements.
	
6. **Write a POST-MORTEM to report findings**.  

## Current status

The project is finished. See POST-MORTEM.md
  
## How to run

Install the dmd environment. Then on Linux or Windows:  
```dub run``` 

Up, down, right, left: **arrow keys**  
Pause the game: **scroll lock**  
Exit the game: **Esc**  
  
On Linux, the terminal is updated only when you press a key, so even if the  
snake moves by itself, keep pressing arrows in the direction you want to go.  
You will understand what I mean when testing the game.  
  