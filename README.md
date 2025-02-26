# 🐒 Towards a Quantitative Understanding of Collective Animal Behaviour Under Climatic Events

Climate change poses significant threats to biodiversity, with extreme weather events such as hurricanes and wildfires devastating animal populations at unprecedented scales. Animals exhibit **collective behaviours** to respond to such threats, emerging from interactions among individuals within a group. Understanding these interaction dynamics is key to uncovering **self-organization** and **decision-making** mechanisms in animal populations.  

This project aims to explore these behaviours through a combination of **mathematical modeling, simulations, and empirical data collection**.  

---

## 🌍 Case Study: Macaque Survival During Hurricane Maria

The **2017 Hurricane Maria** struck Cayo Santiago, home to a colony of **rhesus macaques**, yet an astounding **98% of the population survived**. This event was chosen as a **primary case study** due to its relevance in understanding how collective behaviour and leadership influence survival in extreme climatic conditions.  

---

## 🔬 Mathematical Model  

A **dynamical system** was developed to model the macaque population as **interacting agents**, driven by social forces and environmental factors. The model distinguishes between:  
- **Followers**, who respond to local interactions and external conditions  
- **Leaders**, who anticipate the hurricane trajectory and guide the group  

### **Agent-Based Formulation**  
The colony is represented as a system of agents:  
\[
\{(\mathbf{x}_i, \mathbf{v}_i)\}_{i=1}^N
\]
where \( \mathbf{x}_i, \mathbf{v}_i \in \mathbb{R}^2 \) denote the **position** and **velocity** of the \( i \)-th agent. Each agent follows **Newton’s Second Law**:  
\[
\ddot{\mathbf{x}}_i = \mathbf{F}^{\text{endo}}_i + \mathbf{F}^{\text{exo}}_i
\]
where:  
- \( \mathbf{F}^{\text{endo}}_i \) represents **social interaction forces**  
- \( \mathbf{F}^{\text{exo}}_i \) accounts for **environmental influences** (hurricane impact)  

### **Social Interaction Forces**  
Agents interact within a **local neighborhood** \( \mathcal{N} \), incorporating:  
\[
F_{i}^{\text{endo}} =  \sum\limits_{\substack{j\in\mathcal{N}}} 
C_{1} (\mathbf{x}_j - \mathbf{x}_i) \mathbb{I}_{(\|\mathbf{x}_j - \mathbf{x}_i\| > r_1)}
- C_{2} e^{-\|\mathbf{x}_j - \mathbf{x}_i\|^\gamma} \frac{\mathbf{x}_j - \mathbf{x}_i}{\|\mathbf{x}_j - \mathbf{x}_i\|}
\mathbb{I}_{(\|\mathbf{x}_j - \mathbf{x}_i\| \leq r_2)}
\]
where:  
- \( C_1, C_2 \) define **attraction** and **repulsion** strengths  
- \( r_1, r_2 \) set interaction ranges  
- **Followers** are strongly attracted to leaders  

### **Environmental Influence (Hurricane)**
Agents are also influenced by the **storm's trajectory**, modeled as:  
\[
\mathbf{F}^{\text{exo}}_i = \Phi(\mathbf{x}_i) \cdot \hat{\mathbf{n}}_i + \kappa \frac{\mathbf{x}_i - \mathbf{x}_{c}(t)}{\|\mathbf{x}_i - \mathbf{x}_{c}(t)\|^3}
\]
where:  
- \( \Phi(\mathbf{x}_i) \) is the **wind power**  
- \( \mathbf{x}_c(t) \) is the **storm center**  
- \( \kappa \) is the **repulsion strength**  

Leaders anticipate the storm’s path within a time window \( \Delta t \):  
\[
\mathbf{F}^{\text{exo}}_{\text{leader}} = \Phi(\mathbf{x}_i) \cdot \hat{\mathbf{n}}_i + \kappa \int\limits_t^{t+\Delta t} \frac{\mathbf{x}_i - \mathbf{x}_{c}(s)}{\|\mathbf{x}_i - \mathbf{x}_{c}(s)\|^3} ds
\]

---

## 🎮 Simulations  

Computational experiments modeled a **group of macaques** responding to an approaching hurricane.  

Key findings:  
✔ **Leaders play a crucial role** in guiding followers to safety  
✔ **Without leadership, mortality rates increase significantly**  
✔ **Stronger social ties** improve survival chances  

### **Simulation 1: Leadership Enhances Survival**  
![Leader Simulation](figures/leader_simulation.gif)  

### **Simulation 2: No Leader, Higher Mortality**  
![No Leader Simulation](figures/no_leader_simulation.gif)  

---

## 🔧 Running the Code  

### **Installation**  
Ensure you have Python 3.x installed. Install dependencies via:  
```bash
pip install numpy matplotlib scipy


