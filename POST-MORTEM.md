# Dlang contract programming (CP) and unittesting Vs. strong requirements

- In the first section, I give some context to the project
- Then I match the requirements to the actual implementation
- Finally, I give my conclusion about Dlang CP and unittesting

## Example of the aeronautical industry

Let's take the example of onboard aeronautical software. In the projects I saw,  
embedded subsystems are coded in C or ADA and more important components in ADA.  

- obviously, the use of C is due to legacy codebase and dev habits. C++ can do  
    everything C does, but is still evolving as a language, compiles as fast  
 	if not faster, has OOP, templates... Could C++ be used instead of C? Well  
	it carries over all the problems of C, including buffer overflow! It grew  
	to off-putting complexity over time. Moreover, C++ does not propose CP and  
	relies on external tools, while Concepts are just being introduced.  
	
- ADA is great for critical software. Among others, it has CP and super strong  
    typing. But here is the first problem, who needs super strong typing when  
	you can write 'auto var' and let the compiler do the job? ADA has another  
	off-putting peculiarity: the official toolchain is proprietary, which does  
	not help an already niche language.  
	
With this quick example, we immediately understand that there is no middle  
ground, but Dlang seems a good candidate to fill the gap, having CP and unit-  
testing as core features. See [Programming in D documentation](http://ddili.org/ders/d.en/contracts.html)

## SnakeD requirements review

As explained in the README, I found a project describing requirements but*I did*  
*not read them* beforehand. Instead, I applied Dlang CP to the best of my  
knowledge and asked for code review. Then I read the requirements from the  
student project and [translated them with minor modifications](https://github.com/Fr3nchK1ss/SnakeD/blob/master/Requirements/Snake%20game%20requirements.pdf). Let's now see how  
much coverage I was able to obtain out of the blue.  

### CP check of requirements

1. I did not check for the maximum size of the snake. So if the snake fills the  
    entire playground, the player will not win. Not checking the maximum length  
	is definitely an oversight. However, it is checked indirectly when trying  
	to add a new food token to the  playground: if there is no more empty cell  
	to put a token, that also means the snake has grown to fill the entire  
	playground.
2. Implemented, part of basic gameplay.
3. ditto
4. Implemented, out contract on updateFoodToken()
5. Implemented, isSnakeInsidePlayground() contract function
6. There is no CP to check if eating a food token makes this one disappear.  
    This is an oversight. Obviously, the token does disappear from the display,  
	because the token is replaced by the snake's head, but code-wise, there is  
	no CP to check for the unicity of the token at each iteration.  
7. Implemented, part of basic gameplay.  
8. ditto  
9. ditto
10. There is a contract using isBackTracking() which enforces that the snake  
    does not backtrack on its own body, ie head(t+1) != head(t). While a  
	snake can backtrack  in real life, this goes hand in hand with the basic  
	rule that the snake must not collide with itself.
	
### Testing of requirements

1. Screen filling: No unittest because the use case was not considered  
2. Collision: ok, unittest of updateSnakePosition()  
3. Terrain display: irrelevant, that would be a visual test.  
4. Token position: ok, unittest of updateFoodToken (stress test)  
5. Snake position: no stress test, could be
6. Tc.6.1 is a visual test again, but tc.6.2 could have a unittest  
7. Score increase: No unittest, could have one
8. Snake growth: updateBody() unittest provides partial coverage.
9. Input keys: that would be a gameplay test, but partial coverage is provided  
    by chance in updateBody() unitest, when using Direction.DOWN, and in  
	updateSnakePosition() unittest when using UP and RIGHT.  
10. Body position: ok, unittest in updateBody()


### Body count

Out of the ten requirements, 5 are fulfilled by definition, meaning the game  
can not start working without them. Of the remaining 5, 3 have their contracts  
and 2 possible contracts were overlooked.

Testing-wise, I count 8 possible unittests , out of which 3 were done, 2 were  
partially done by chance, 3 were overlooked.

### Discussion

I immediately see a problem here: several requirements would need a simulation  
of user input, and that was a complete oversight. In other words, my app.d  
should have a unittest, which is perfectly possible in Dlang.  
  
There is also the problem of visual testing, for example testing that the  
borders are displayed correctly. This is due to this program being an HMI and  
would require a meta layer, out of the scope of this project.

## Conclusion

Generally speaking, I consider the result positive. Note that I coded the dirty  
way, without any preparatory thinking about the design or anything, taking  
inspiration from Internet.
  
- Still, 8 out of 10 requirements of someone else's design of the same kind of  
    game are fulfilled by a standard CP practice. The remaining contracts would be  
    easy to implement in Dlang.  
  
- The unittest coverage is lacking, which is certainly due to my lack of unittest  
    experience. However, it would be trivial to implement in Dlang. The disturbing  
	factor to me, is that unittest code already accounts for a good percentage of  
	the total LoC (32% in ground.d), while still being far from exhaustive.  

- I did not have any problem coding the unittests or setting the contracts, the  
    D syntax is simple and "dub test" worked out of the box.  

The CP/unittests did stop me in my tracks a few times, ie they revealed errors  
in my code that I did not forsee. They are definitely useful even at the level  
of the programmer, and lacking in C / C++.
  
Now, on a higher level, and considering all the work  necessary to write them,  
I would say one could almost build a  language around the CP/unittests feature,  
instead of building a language and then add those features. This probably  
explains why a language like ADA remains necessary.
   

Fr3nchK1ss  
This document is public domain.  
