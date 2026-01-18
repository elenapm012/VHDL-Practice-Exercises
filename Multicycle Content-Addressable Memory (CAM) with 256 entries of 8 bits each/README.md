# Design and implementation of a fully synthesizable multicycle Content-Addressable Memory (CAM) in VHDL with 256 entries of 8 bits each.

The memory supports two operating modes: write and search (read). During a write operation (WENB = '0'), the input tag data is stored in the memory location specified by ADDR_IN. During a search operation (RENB = '0'), the memory sequentially scans all entries to find a match with the input tag data.

If the tag is found during the search, the MATCH signal is asserted. The output address (MEM_SAL) remains in high impedance during the search process and is only driven at the end of the search cycle. When a match is detected at the end of the scan, MATCH_VALID is asserted and MEM_SAL outputs the address of the matching entry.

If no match is found, MATCH remains deasserted, MATCH_VALID stays low, and the output remains in high impedance. The design is fully synthesizable and follows a multicycle architecture, ensuring that the output is always produced at the end of the search operation.