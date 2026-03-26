package model;

import jakarta.persistence.*;
import java.sql.Timestamp;

@Entity
@Table(name = "AlgaeRecords", indexes = {
    @Index(name = "idx_duplicate_check", columnList = "SpeciesGroup, SignatureSequence, Nucleotides")
})
public class AlgaeRecord {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "RecordID")
    private int recordID;

    @Column(name = "SpeciesGroup", nullable = false, length = 200)
    private String speciesGroup;

    @Column(name = "SignatureSequence", nullable = false, length = 500)
    private String signatureSequence;

    @Column(name = "Nucleotides", nullable = false)
    private int nucleotides;

    @Column(name = "CreatedAt", nullable = false, updatable = false,
            insertable = false, columnDefinition = "TIMESTAMP DEFAULT CURRENT_TIMESTAMP")
    private Timestamp createdAt;

    @Column(name = "UpdatedAt", nullable = false,
            insertable = false, columnDefinition = "TIMESTAMP DEFAULT CURRENT_TIMESTAMP")
    private Timestamp updatedAt;

    public AlgaeRecord() {
    }

    public AlgaeRecord(String speciesGroup, String signatureSequence, int nucleotides) {
        this.speciesGroup = speciesGroup;
        this.signatureSequence = signatureSequence;
        this.nucleotides = nucleotides;
    }

    public int getRecordID() {
        return recordID;
    }

    public void setRecordID(int recordID) {
        this.recordID = recordID;
    }

    public String getSpeciesGroup() {
        return speciesGroup;
    }

    public void setSpeciesGroup(String speciesGroup) {
        this.speciesGroup = speciesGroup;
    }

    public String getSignatureSequence() {
        return signatureSequence;
    }

    public void setSignatureSequence(String signatureSequence) {
        this.signatureSequence = signatureSequence;
    }

    public int getNucleotides() {
        return nucleotides;
    }

    public void setNucleotides(int nucleotides) {
        this.nucleotides = nucleotides;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
}
